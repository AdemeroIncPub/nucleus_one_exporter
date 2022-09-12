import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:url_launcher/link.dart';

import '../application/constants.dart';
import '../application/providers.dart';
import '../application/services/user_orgs_summary_service.dart';
import 'util/dialog_helper.dart';
import 'util/style.dart';

class ExportSettingsScreen extends ConsumerStatefulWidget {
  const ExportSettingsScreen({super.key});

  @override
  ConsumerState createState() => _ExportSettingsScreenState();
}

class _ExportSettingsScreenState extends ConsumerState<ExportSettingsScreen> {
  final apiKeyTextFieldController = TextEditingController();
  final destinationTextFieldController = TextEditingController();
  final maxDownloadsTextFieldController = TextEditingController(text: '4');

  bool allowNonEmptyDestination = false;
  bool copyIfExists = false;
  AsyncValue<UserOrgsSummary> userOrgsSummary = const AsyncLoading();

  String? selectedOrgId;
  String? selectedProjectId;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    apiKeyTextFieldController.text = settings.apiKey;
  }

  @override
  Widget build(BuildContext context) {
    userOrgsSummary = ref.watch(userOrgsSummaryProvider);

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

  Column _mainContent() {
    return Column(
      children: [
        Text(
          productName,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: Insets.compSmall),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _introText(),
                const SizedBox(height: Insets.compSmall),
                _settingsTable(),
                const SizedBox(height: Insets.compLarge),
                _exportButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _introText() {
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
              const TextSpan(text: '.'),
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
        _apiKeyControlsRow(),
        _spacerRow(height: Insets.compSmall),
        _refreshDataRow(),
        _spacerRow(height: Insets.compSmall),
        _orgDropdownRow(),
        _spacerRow(height: Insets.compSmall),
        _projectDropdownRow(),
        _spacerRow(height: Insets.compSmall),
        _destinationControlsRow(),
        _spacerRow(height: Insets.compSmall),
        _optionControlsRow(),
        _spacerRow(height: Insets.compSmall),
        _maxConcurrentDownloadsControlsRow(),
      ],
    );
  }

  TableRow _apiKeyControlsRow() {
    return _buildTableRow(
      item1: IconButton(
        icon: const Icon(Icons.edit),
        tooltip: 'Edit',
        onPressed: () async {
          final apiKey = await showTextInputDialog(
            context,
            contentConstraints: const BoxConstraints(minWidth: 500),
            title: const Text('Set API Key'),
            text: apiKeyTextFieldController.text,
            helperText:
                'Generate API keys in your profile in the Nucleus One web app.',
            hintText: 'Your API Key',
          );
          if (apiKey != null) {
            apiKeyTextFieldController.text = apiKey;
            ref.read(settingsProvider.notifier).setApiKey(apiKey);
          }
        },
      ),
      item2: SelectionArea(
        child: TextField(
          controller: apiKeyTextFieldController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'API Key',
            hintText: 'Use the edit button to set your API key.',
            errorText: userOrgsSummary.whenOrNull(
              error: (error, stackTrace) {
                if (error is n1.HttpException) {
                  return 'Error connecting to Nucleus One. Please verify your API key is correct.';
                }
                return 'Unknown error connecting to Nucleus One.';
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
        onPressed: () {
          ref.refresh(userOrgsSummaryProvider);
        },
        child: const Text('⟳ Refresh organization and project lists'),
      ),
    );
  }

  TableRow _orgDropdownRow() {
    final items = userOrgsSummary.whenOrNull(
      data: (summaryInfo) {
        return summaryInfo.orgInfos.map(
          (orgInfo) => DropdownMenuItem(
            value: orgInfo.id,
            child: Text(orgInfo.name),
          ),
        );
      },
    );

    return _buildTableRow(
      item2: DropdownButton(
        value: _existingDropdownValueOrNull(
          selectedOrgId,
          items?.map((item) => item.value!),
        ),
        hint: const Text('Select Organization'),
        items: items?.toList(),
        onChanged: (value) {
          setState(() {
            selectedOrgId = value;
          });
        },
      ),
    );
  }

  TableRow _projectDropdownRow() {
    final items = userOrgsSummary.whenOrNull(
      data: (summaryInfo) {
        final selectedOrg = summaryInfo.orgInfos
            .firstWhereOrNull((orgInfo) => orgInfo.id == selectedOrgId);
        return selectedOrg?.projectInfos.map(
          (projectInfo) => DropdownMenuItem(
            value: projectInfo.id,
            child: Text(projectInfo.name),
          ),
        );
      },
    );

    return _buildTableRow(
      item2: DropdownButton(
        value: _existingDropdownValueOrNull(
          selectedProjectId,
          items?.map((item) => item.value!),
        ),
        hint: const Text('Select Project'),
        items: items?.toList(),
        onChanged: (value) {
          setState(() {
            selectedProjectId = value;
          });
        },
      ),
    );
  }

  TableRow _destinationControlsRow() {
    return _buildTableRow(
      item1: IconButton(
        icon: const Icon(Icons.edit),
        tooltip: 'Edit',
        onPressed: () async {
          final destination = await FilePicker.platform.getDirectoryPath(
            dialogTitle: 'Select export destination folder.',
            initialDirectory: destinationTextFieldController.text,
            lockParentWindow: true,
          );
          if (destination != null) {
            destinationTextFieldController.text = destination;
          }
        },
      ),
      item2: SelectionArea(
        child: TextField(
          controller: destinationTextFieldController,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Destination',
            hintText: 'Use the edit button to set your destination path.',
          ),
        ),
      ),
    );
  }

  TableRow _optionControlsRow() {
    return _buildTableRow(
      item2: Column(
        children: [
          CheckboxListTile(
            title: const Text('Allow non-empty destination'),
            subtitle: const Text(
                'If checked, allow export even if destination contains files or folders.'),
            controlAffinity: ListTileControlAffinity.leading,
            value: allowNonEmptyDestination,
            onChanged: (value) {
              setState(() {
                allowNonEmptyDestination = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Copy if exists'),
            subtitle: const Text(
                'Create a copy if the file already exists (otherwise skip).'),
            controlAffinity: ListTileControlAffinity.leading,
            value: copyIfExists,
            onChanged: (value) {
              setState(() {
                copyIfExists = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  TableRow _maxConcurrentDownloadsControlsRow() {
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
                controller: maxDownloadsTextFieldController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ),
          const SizedBox(width: Insets.compSmall),
          Expanded(
            child: Text(
              'Maximum number of documents to download simultaneously.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _exportButton() {
    return ElevatedButton(
      onPressed: userOrgsSummary.whenOrNull(
        data: (data) => () async {
          //validate
        },
      ),
      child: const Text('Export Documents'),
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
