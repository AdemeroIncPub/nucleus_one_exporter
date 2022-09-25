import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../application/constants.dart';
import '../application/providers.dart';
import '../application/services/export_documents_args.dart';
import 'export_screen_state.dart';
import 'util/style.dart';

final exportDocumentsProvider = StateNotifierProvider.family<
    ExportStateNotifier, AsyncValue<ExportState>, ValidatedExportDocumentsArgs>(
  (ref, validArgs) {
    final exportServiceAsync = ref.watch(exportServiceProvider);
    return ExportStateNotifier(exportServiceAsync, validArgs);
  },
);

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key, required this.validArgs});

  static const route = '/ExportScreen';

  final ValidatedExportDocumentsArgs validArgs;

  @override
  ConsumerState createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen>
    with
        // ignore: prefer_mixin
        WindowListener {
  late final _exportDocumentsProviderWithArgs =
      exportDocumentsProvider(widget.validArgs);

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    unawaited(_init());
  }

  @override
  Future<void> onWindowClose() async {
    final bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      final cancelExport = await _confirmCancelExport();
      if (cancelExport ?? false) {
        await windowManager.destroy();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(_exportDocumentsProviderWithArgs, _exportDocumentsListener);
    final exportState = ref.watch(_exportDocumentsProviderWithArgs);

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(Insets.compLarge).copyWith(top: 12),
        child: Column(
          children: [
            _titleText(),
            const SizedBox(height: Insets.compSmall),
            _logLabel(),
            const SizedBox(height: Insets.compSmall),
            Expanded(
              child: exportState.when(
                data: _data,
                error: _error,
                loading: _loading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _init() async {
    await windowManager.setPreventClose(true);
  }

  Widget _titleText() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        productName,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }

  Align _logLabel() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        'Last 100 log messages:',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _data(ExportState exportState) {
    const prefixExported = '[Exported] ';
    const prefixAsCopy = '[Exported As Copy] ';
    const prefixExists = '[Skipped (Already Exists)] ';
    const prefixFailure = '[Skipped (Unknown Failure)] ';

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: exportState.recentExportEvents.length,
            itemBuilder: (context, index) {
              return _listItem(exportState, index, prefixAsCopy, prefixExported,
                  prefixExists, prefixFailure);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: Insets.compXSmall);
            },
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: clampDouble(exportState.percent / 100, 0, 1),
              ),
            ),
            const SizedBox(width: Insets.compMedium),
            Text(
              '${exportState.percent}%',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: Insets.compMedium),
        Row(
          children: [
            if (exportState.isFinished)
              _closeButton()
            else
              _cancelButton(enabled: !exportState.wasCancelRequested),
            if (!exportState.isFinished && exportState.wasCancelRequested) ...[
              const SizedBox(width: Insets.compMedium),
              ..._cancelInProgress(),
            ],
          ],
        ),
      ],
    );
  }

  Widget _listItem(ExportState exportState, int index, String prefixAsCopy,
      String prefixExported, String prefixExists, String prefixFailure) {
    final theme = Theme.of(context);

    return exportState.recentExportEvents[index].maybeWhen(
      orElse: () {
        assert(false, 'This event is not reported.');
        return Container();
      },
      docExported: (docId, n1Path, localPath, exportedAsCopy) {
        final msg = 'Document ID: "$docId", N1 Path: "$n1Path", '
            'Local Path: "$localPath"';
        if (exportedAsCopy) {
          return Text(
            '$prefixAsCopy$msg',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: Colors.amber.shade200),
          );
        } else {
          // todo(apn): selection in ui for all, warnings, errors (chips?)
          return Text('$prefixExported$msg');
        }
      },
      docSkippedAlreadyExists: (docId, n1Path, localPath) {
        final msg = 'Document ID: "$docId", N1 Path: "$n1Path", '
            'Local Path: "$localPath"';
        return Text(
          '$prefixExists$msg',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: Colors.amber.shade200),
        );
      },
      docSkippedUnknownFailure: (docId, n1Path) {
        final msg = 'Document ID: "$docId", N1 Path: "$n1Path"';
        return Text(
          '$prefixFailure$msg',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.error),
        );
      },
    );
  }

  Widget _cancelButton({required bool enabled}) {
    return ElevatedButton(
      onPressed: (!enabled)
          ? null
          : () async {
              final cancelExport = await _confirmCancelExport();
              if (cancelExport ?? false) {
                ref
                    .read(_exportDocumentsProviderWithArgs.notifier)
                    .cancelExport();
              }
            },
      child: const Text('CANCEL'),
    );
  }

  Widget _closeButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('CLOSE'),
    );
  }

  List<Widget> _cancelInProgress() {
    return [
      const CircularProgressIndicator(),
      const SizedBox(width: Insets.compSmall),
      Text(
        'Cancel in progress, finishing documents already started...',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    ];
  }

  Widget _error(Object error, [StackTrace? stackTrace]) {
    // todo(apn): handle error
    return Column(
      children: [
        Expanded(child: Text(error.toString())),
        _cancelButton(enabled: true),
      ],
    );
  }

  Widget _loading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: FractionallySizedBox(
                heightFactor: 0.25,
                widthFactor: 0.25,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        _cancelButton(enabled: true),
      ],
    );
  }

  void _exportDocumentsListener(
      AsyncValue<ExportState>? previous, AsyncValue<ExportState> next) {
    TableRow createTableRow({required String label, required String? value}) {
      return TableRow(
        children: [
          Text(
            label,
            softWrap: false,
          ),
          Text(
            ': ${value ?? 'unknown'}',
            softWrap: false,
          ),
        ],
      );
    }

    final exportState = next.asData?.value;
    if (exportState != null && exportState.isFinished) {
      unawaited(windowManager.setPreventClose(false));
      final r = exportState.exportResults;
      final content = Table(
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
        },
        children: [
          createTableRow(
            label: 'Total Documents Exported',
            value: r?.totalExported.toString(),
          ),
          createTableRow(
            label: 'Total Documents Attempted',
            value: r?.totalAttempted.toString(),
          ),
          if (widget.validArgs.copyIfExists)
            createTableRow(
              label: 'Exported as a Copy',
              value: r?.exportedAsCopy.toString(),
            )
          else
            createTableRow(
              label: 'Skipped (Already Exists)',
              value: r?.skippedAlreadyExists.toString(),
            ),
          createTableRow(
            label: 'Skipped (Unknown Failure)',
            value: r?.skippedUnknownFailure.toString(),
          ),
          createTableRow(
            label: 'Total Export Time',
            value: r?.elapsed.toString(),
          ),
        ],
      );

      // close confirm cancel dialog if open
      Navigator.popUntil(
        context,
        (route) => route.settings.name == ExportScreen.route,
      );

      unawaited(showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: (!exportState.wasCanceledBeforeFinish)
              ? const Text('Export Complete')
              : const Text('Export Canceled'),
          content: content,
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('CLOSE'),
            )
          ],
        ),
      ));
    }
  }

  Future<bool?> _confirmCancelExport() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Export'),
          content: const Text('Would you like to cancel the export?'),
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            TextButton(
              child: const Text('CONTINUE EXPORT'),
              onPressed: () => Navigator.pop(context, false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('CANCEL EXPORT'),
            ),
          ],
        );
      },
    );
  }
}
