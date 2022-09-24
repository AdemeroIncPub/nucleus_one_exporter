import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/constants.dart';
import '../application/providers.dart';
import '../application/services/export_documents_args.dart';
import 'export_screen_state.dart';
import 'util/style.dart';

final exportDocumentsProvider = StateNotifierProvider.autoDispose.family<
    ExportStateNotifier, AsyncValue<ExportState>, ValidatedExportDocumentsArgs>(
  (ref, validArgs) {
    final exportServiceAsync = ref.watch(exportServiceProvider);
    return ExportStateNotifier(exportServiceAsync, validArgs);
  },
);

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key, required this.validArgs});

  final ValidatedExportDocumentsArgs validArgs;

  @override
  ConsumerState createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  late final _exportDocumentsProviderWithArgs =
      exportDocumentsProvider(widget.validArgs);

  @override
  Widget build(BuildContext context) {
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
        Align(
          alignment: Alignment.topLeft,
          child: (exportState.isFinished) ? _closeButton() : _cancelButton(),
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

  Widget _cancelButton() {
    return ElevatedButton(
      onPressed: () {
        ref.read(_exportDocumentsProviderWithArgs.notifier).cancelExport();
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

  Widget _error(Object error, [StackTrace? stackTrace]) {
    // todo(apn): handle error
    return Column(
      children: [
        Expanded(child: Text(error.toString())),
        _cancelButton(),
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
        _cancelButton(),
      ],
    );
  }
}
