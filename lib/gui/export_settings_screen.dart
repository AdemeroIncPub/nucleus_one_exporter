import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:path/path.dart' as path_;
import 'package:url_launcher/link.dart';

import '../application/constants.dart';
import '../application/path_validator.dart';
import '../application/providers.dart';
import '../application/services/export_documents_args.dart';
import '../application/services/user_orgs_summary_service.dart';
import 'export_screen.dart';
import 'util/dialog_helper.dart';
import 'util/style.dart';

class ExportSettingsScreen extends ConsumerStatefulWidget {
  const ExportSettingsScreen({super.key});

  @override
  ConsumerState createState() => _ExportSettingsScreenState();
}

class _ExportSettingsScreenState extends ConsumerState<ExportSettingsScreen> {
  static const _allowNonEmptyDestinationLabel = 'Allow non-empty destination';
  static const _copyIfExistsLabel = 'Copy if exists';
  static const _maxConcurrentDownloadsLabel =
      'Maximum number of documents to download simultaneously';

  final _apiKeyTextFieldController = TextEditingController();
  final _destinationTextFieldController = TextEditingController();
  final _logFileTextFieldController = TextEditingController();
  final _maxDownloadsTextFieldController = TextEditingController(text: '4');

  bool _allowNonEmptyDestination = false;
  bool _copyIfExists = false;
  AsyncValue<UserOrgsSummary> _userOrgsSummary = const AsyncLoading();

  String? _selectedOrgId;
  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _apiKeyTextFieldController.text = settings.apiKey;
  }

  @override
  Widget build(BuildContext context) {
    _userOrgsSummary = ref.watch(userOrgsSummaryProvider);

    return Scaffold(
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          primary: true,
          child: Container(
            margin: const EdgeInsets.all(Insets.compLarge).copyWith(top: 12),
            child: _mainContent(),
          ),
        ),
      ),
    );
  }

  Future<void> _exportDocuments() async {
    final logFileText = _logFileTextFieldController.text;
    final validArgs = ExportDocumentsArgs(
      orgId: _selectedOrgId ?? '',
      projectId: _selectedProjectId ?? '',
      destination: _destinationTextFieldController.text,
      allowNonEmptyDestination: _allowNonEmptyDestination,
      copyIfExists: _copyIfExists,
      maxConcurrentDownloads: _maxDownloadsTextFieldController.text,
      logFile: (logFileText.isNotEmpty) ? logFileText : null,
    ).validate(PathValidator());

    await validArgs.bimap(
      (l) async {
        final messages = l.map((failures) {
          // The UI should prevent a number of these cases from happening, but...
          switch (failures) {
            case ExportDocumentsArgsValidationFailure.orgIdMissing:
              return 'Select an organization.';
            case ExportDocumentsArgsValidationFailure.projectIdMissing:
              return 'Select a project.';
            case ExportDocumentsArgsValidationFailure.destinationMissing:
              return 'Select a destination.';
            case ExportDocumentsArgsValidationFailure.destinationInvalid:
              return 'Destination is not a valid path.';
            case ExportDocumentsArgsValidationFailure.destinationNotEmpty:
              return 'The destination folder already exists and is not empty. '
                  'Check "$_allowNonEmptyDestinationLabel" to export anyway.';
            case ExportDocumentsArgsValidationFailure.maxDownloadsInvalid:
              return '"$_maxConcurrentDownloadsLabel" must be a '
                  'number greater than zero.';
            case ExportDocumentsArgsValidationFailure.logFileInvalid:
              return 'The log file path is not a valid path.';
            case ExportDocumentsArgsValidationFailure.unknownFailure:
              return 'An unknown failure has ocurred.';
          }
        });

        await showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              scrollable: true,
              title: const Align(
                alignment: Alignment.center,
                child: Text('Export Issues'),
              ),
              content: Container(
                constraints: const BoxConstraints(maxWidth: 550),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Please correct the following issue(s):'),
                    ...messages.expand(
                      (msg) => [
                        const SizedBox(height: Insets.compSmall),
                        Text(msg),
                      ],
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.start,
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      (r) async => Navigator.of(context).push(MaterialPageRoute<void>(
        settings: const RouteSettings(name: ExportScreen.route),
        builder: (_) => ExportScreen(validArgs: r),
      )),
    ).run();
  }

  Widget _mainContent() {
    // This Align pushes the scrollbar all the way to the right.
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleText(),
            const SizedBox(height: Insets.compSmall),
            _headerText(),
            const SizedBox(height: Insets.compSmall),
            _settingsTable(),
            const SizedBox(height: Insets.compLarge),
            _footerText(),
            const SizedBox(height: Insets.compLarge),
            _exportButton(),
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

  Column _headerText() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                  text: 'Export your Nucleus One documents to a local path.\n'),
              const TextSpan(
                  text: 'For more information about Nucleus One, visit '),
              WidgetSpan(
                child: Link(
                  uri: Uri.parse(marketingUrl),
                  builder: (context, followLink) {
                    return RichText(
                      text: TextSpan(
                        text: marketingUrl,
                        style: theme.textTheme.bodyMedium?.apply(
                          fontWeightDelta: 1,
                          color: theme.colorScheme.primary,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = followLink,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Table _settingsTable() {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
      },
      textBaseline: TextBaseline.alphabetic,
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      children: [
        _apiKeyRow(),
        _spacerRow(height: Insets.compSmall),
        _refreshDataRow(),
        _spacerRow(height: Insets.compSmall),
        _orgDropdownRow(),
        _spacerRow(height: Insets.compSmall),
        _projectDropdownRow(),
        _spacerRow(height: Insets.compSmall),
        _destinationRow(),
        _spacerRow(height: Insets.compSmall),
        _optionsRow(),
        _spacerRow(height: Insets.compSmall),
        _maxConcurrentDownloadsRow(),
        _spacerRow(height: Insets.compSmall),
        _logFileRow()
      ],
    );
  }

  TableRow _apiKeyRow() {
    return _buildTableRow(
      item1: IconButton(
        icon: const Icon(Icons.edit),
        tooltip: 'Edit',
        onPressed: () async {
          final apiKey = await showTextInputDialog(
            context,
            contentConstraints: const BoxConstraints(minWidth: 500),
            title: const Text('Set API key'),
            text: _apiKeyTextFieldController.text,
            helperText:
                'Generate API keys in your profile in the Nucleus One web app',
            hintText: 'Your API key',
          );
          if (apiKey != null) {
            _apiKeyTextFieldController.text = apiKey;
            ref.read(settingsProvider.notifier).setApiKey(apiKey);
          }
        },
      ),
      item2: SelectionArea(
        child: TextField(
          controller: _apiKeyTextFieldController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'API key',
            hintText: 'Use the edit button to set your API key',
            errorText: _userOrgsSummary.whenOrNull(
              error: (error, stackTrace) {
                if (error is n1.HttpException) {
                  return 'Error connecting to Nucleus One. Please verify your API key is correct';
                }
                return 'Unknown error connecting to Nucleus One';
              },
            ),
          ),
        ),
      ),
    );
  }

  TableRow _refreshDataRow() {
    return _buildTableRow(
      item2: TextButton(
        onPressed: _userOrgsSummary.whenOrNull(
          data: (_) => () => ref.refresh(userOrgsSummaryProvider),
        ),
        child: const Text('⟳ Refresh organization and project lists'),
      ),
    );
  }

  TableRow _orgDropdownRow() {
    final items = _userOrgsSummary.asData?.value.orgInfos.map(
      (orgInfo) => DropdownMenuItem(
        value: orgInfo.id,
        child: Text(orgInfo.name),
      ),
    );

    return _buildTableRow(
      item2: DropdownButton(
        value: _existingDropdownValueOrNull(
          _selectedOrgId,
          items?.map((item) => item.value!),
        ),
        hint: const Text('Select organization'),
        items: items?.toList(),
        onChanged: (value) {
          setState(() {
            _selectedOrgId = value;
          });
        },
      ),
    );
  }

  TableRow _projectDropdownRow() {
    final items = _userOrgsSummary.asData?.value.orgInfos
        .firstWhereOrNull((orgInfo) => orgInfo.id == _selectedOrgId)
        ?.projectInfos
        .map((projectInfo) => DropdownMenuItem(
              value: projectInfo.id,
              child: Text(projectInfo.name),
            ));

    return _buildTableRow(
      item2: DropdownButton(
        value: _existingDropdownValueOrNull(
          _selectedProjectId,
          items?.map((item) => item.value!),
        ),
        hint: const Text('Select project'),
        items: items?.toList(),
        onChanged: (value) {
          setState(() {
            _selectedProjectId = value;
          });
        },
      ),
    );
  }

  TableRow _destinationRow() {
    return _buildTableRow(
      item1: IconButton(
        icon: const Icon(Icons.edit),
        tooltip: 'Browse',
        onPressed: () async {
          final destination = await FilePicker.platform.getDirectoryPath(
            dialogTitle: 'Select export destination folder',
            initialDirectory: _destinationTextFieldController.text,
            lockParentWindow: true,
          );
          if (destination != null) {
            _destinationTextFieldController.text = destination;
            setState(() {}); // update Export button state
          }
        },
      ),
      item2: SelectionArea(
        child: TextField(
          controller: _destinationTextFieldController,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Destination',
            hintText: 'Use the edit button to set your destination path',
          ),
        ),
      ),
    );
  }

  TableRow _optionsRow() {
    return _buildTableRow(
      item2: Column(
        children: [
          CheckboxListTile(
            title: const Text(_allowNonEmptyDestinationLabel),
            subtitle: const Text(
                'If checked, allow export even if destination contains files or folders'),
            controlAffinity: ListTileControlAffinity.leading,
            value: _allowNonEmptyDestination,
            onChanged: (value) {
              setState(() {
                _allowNonEmptyDestination = value!;
              });
            },
          ),
          const SizedBox(height: Insets.compXSmall),
          CheckboxListTile(
            title: const Text(_copyIfExistsLabel),
            subtitle: const Text(
                'Create a copy if the file already exists (otherwise skip)'),
            controlAffinity: ListTileControlAffinity.leading,
            value: _copyIfExists,
            onChanged: (value) {
              setState(() {
                _copyIfExists = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  TableRow _maxConcurrentDownloadsRow() {
    return _buildTableRow(
      item2: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 30, maxWidth: 50),
            child: IntrinsicWidth(
              child: TextField(
                textAlign: TextAlign.center,
                controller: _maxDownloadsTextFieldController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(RegExp(r'^0')),
                ],
                // setState to enable/disable export button
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),
          const SizedBox(width: Insets.compSmall),
          Expanded(
            child: Text(
              _maxConcurrentDownloadsLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  TableRow _logFileRow() {
    return _buildTableRow(
      item1: IconButton(
        icon: const Icon(Icons.edit),
        tooltip: 'Browse',
        onPressed: () async {
          String? foldername;
          String? filename;
          if (_logFileTextFieldController.text.isNotEmpty) {
            final logFilePath = _logFileTextFieldController.text;
            foldername = path_.dirname(logFilePath);
            filename = path_.basename(logFilePath);
          }
          if (foldername == null &&
              _destinationTextFieldController.text.isNotEmpty) {
            foldername = _destinationTextFieldController.text;
          }
          if (filename == null) {
            final now = DateTime.now();
            final formattedNow = '${now.year.toString()}-'
                '${now.month.toString().padLeft(2, '0')}-'
                '${now.day.toString().padLeft(2, '0')}';
            filename = 'Nucleus_One_Export_$formattedNow.log';
          }

          final logFilePath = await FilePicker.platform.saveFile(
            allowedExtensions: ['log', 'txt'],
            dialogTitle:
                'Export log file (an existing file will be overwritten)',
            initialDirectory: foldername,
            fileName: filename,
            lockParentWindow: true,
          );
          if (logFilePath != null) {
            _logFileTextFieldController.text = logFilePath;
          }
        },
      ),
      item2: SelectionArea(
        child: TextField(
          controller: _logFileTextFieldController,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Log file (optional)',
            hintText:
                'Use the edit button to set a log file (an existing file will be overwritten)',
          ),
        ),
      ),
    );
  }

  Widget _footerText() {
    const text = 'During export, any characters that are not allowed in file '
        'and folder names will be replaced with an underscore. Due to this '
        "renaming, it's possible that the export will save a file with the "
        'same name as another file not yet exported. With "Copy if exists" '
        'unchecked, the second file will be skipped since the file already '
        'exists. A warning will be logged. This mostly affects Windows.';
    return const Text(text);
  }

  Widget _exportButton() {
    final enabled = _selectedOrgId != null &&
        _selectedProjectId != null &&
        _destinationTextFieldController.text.isNotEmpty &&
        _maxDownloadsTextFieldController.text.isNotEmpty;

    return ElevatedButton(
      onPressed: (enabled)
          ? _userOrgsSummary.whenOrNull(
              data: (data) => _exportDocuments,
            )
          : null,
      child: const Text('EXPORT'),
    );
  }

  TableRow _spacerRow({required double height}) {
    return _buildTableRow(item2: SizedBox(height: height));
  }

  TableRow _buildTableRow({Widget? item1, Widget? item2}) {
    return TableRow(children: [
      item1 ?? Container(),
      Align(
        alignment: Alignment.centerLeft,
        child: item2 ?? Container(),
      ),
    ]);
  }

  String? _existingDropdownValueOrNull(
    String? proposedValue,
    Iterable<String>? values,
  ) {
    if (proposedValue == null || values == null) {
      return null;
    }
    if (values.any((v) => v == proposedValue)) {
      return proposedValue;
    }
    return null;
  }
}
