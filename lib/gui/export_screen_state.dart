import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../application/services/export_documents_args.dart';
import '../application/services/export_event.dart';
import '../application/services/export_results.dart';
import '../application/services/export_service.dart';

part 'export_screen_state.freezed.dart';

/// [isFinished] just means no longer processing, could be canceled.
@Freezed(makeCollectionsUnmodifiable: false)
class ExportState with _$ExportState {
  // not const factory since we can't use const recentExportEvents due to
  // modifying it direclty for improved ui performance.
  factory ExportState({
    required List<ExportEvent> recentExportEvents,
    @Default(0) int docsProcessed,
    @Default(0) int percent,
    @Default(0) int totalDocs,
    @Default(false) bool isFinished,
    @Default(false) bool wasCanceledBeforeFinish,
    ExportResults? exportResults,
  }) = __ExportState;
}

class ExportStateNotifier extends StateNotifier<AsyncValue<ExportState>> {
  ExportStateNotifier(
    AsyncValue<ExportService> exportServiceAsync,
    ValidatedExportDocumentsArgs validArgs,
  )   : _exportServiceAsync = exportServiceAsync,
        _validArgs = validArgs,
        super(const AsyncValue.loading()) {
    _exportDocuments();
  }

  final AsyncValue<ExportService> _exportServiceAsync;
  final ValidatedExportDocumentsArgs _validArgs;

  late StreamSubscription<ExportEvent> _exportStreamSubscription;
  var _recentExportEventsIsDirty = false;

  @override
  bool updateShouldNotify(
    AsyncValue<ExportState> old,
    AsyncValue<ExportState> current,
  ) {
    final notify =
        super.updateShouldNotify(old, current) || _recentExportEventsIsDirty;
    _recentExportEventsIsDirty = false;
    return notify;
  }

  /// The export may finish before cancel completes.
  void cancelExport() {
    _exportServiceAsync.asData?.value.cancelExport();
  }

  void _exportDocuments() {
    // https: //github.com/rrousselGit/riverpod/issues/57#issuecomment-1227147293
    state = const AsyncValue.loading();
    _exportServiceAsync.when(
      data: (exportService) {
        final exportStream = exportService.exportDocuments(_validArgs);
        _exportStreamSubscription = exportStream.listen(
          _addEvent,
          onError: (Object error, StackTrace stackTrace) =>
              state = AsyncValue.error(error, stackTrace: stackTrace),
        );
      },
      error: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace: stackTrace);
      },
      loading: () {
        state = const AsyncValue.loading();
      },
    );
  }

  void _addEvent(ExportEvent event) {
    ExportState incrementDocsProcessed(ExportState state) {
      final docsProcessed = state.docsProcessed + 1;
      return state.copyWith(
        docsProcessed: docsProcessed,
        percent: (docsProcessed * 100.0 / state.totalDocs).floor(),
      );
    }

    state.whenOrNull(
      loading: () {
        state = AsyncValue.data(ExportState(recentExportEvents: []));
      },
    );

    state.whenData((state) {
      final newState = event.when(
        beginExport:
            ((orgId, orgName, projectId, projectName, localPath, docCount) {
          return state.copyWith(totalDocs: docCount);
        }),
        docExportAttempt: (docId, n1Path) {
          return state;
        },
        docExported: (docId, n1Path, localPath, exportedAsCopy) {
          _recentExportEventsIsDirty = true;
          state.recentExportEvents.add(event);
          return incrementDocsProcessed(state);
        },
        docSkippedAlreadyExists: (docId, n1Path, localPath) {
          _recentExportEventsIsDirty = true;
          state.recentExportEvents.add(event);
          return incrementDocsProcessed(state);
        },
        docSkippedUnknownFailure: (docId, n1Path) {
          _recentExportEventsIsDirty = true;
          state.recentExportEvents.add(event);
          return incrementDocsProcessed(state);
        },
        exportFinished: (Either<List<ExportFailure>, ExportResults> results,
            canceledBeforeFinish) {
          return state.copyWith(
            isFinished: true,
            wasCanceledBeforeFinish: canceledBeforeFinish,
            exportResults: results.fold(
              (l) => null,
              (r) => r,
            ),
          );
        },
      );

      while (state.recentExportEvents.length > 100) {
        state.recentExportEvents.removeAt(0);
        _recentExportEventsIsDirty = true;
      }

      this.state = AsyncValue.data(newState);
    });
  }
}
