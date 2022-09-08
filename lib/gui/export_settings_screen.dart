import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/link.dart';

import '../application/constants.dart';
import 'util/dialog_helper.dart';
import 'util/style.dart';

const orgList = <String>['org 1', 'org 2', 'org 3'];
const projectList = <String>['project 1', 'project 2', 'project 3'];

class ExportSettingsScreen extends StatefulWidget {
  const ExportSettingsScreen({super.key});

  @override
  State<ExportSettingsScreen> createState() => _ExportSettingsScreenState();
}

class _ExportSettingsScreenState extends State<ExportSettingsScreen> {
  bool allowNonEmptyDestination = false;
  final apiKeyTextFieldController = TextEditingController();
  bool copyIfExists = false;
  final destinationTextFieldController = TextEditingController();
  final maxDownloadsTextFieldController = TextEditingController(text: '4');
  String? orgValue;
  String? projectValue;

  Column _introText(BuildContext context) {
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

  TableRow _apiKeyControlsRow(BuildContext context) {
    return _buildTableRow(
      item1: IconButton(
        icon: const Icon(Icons.edit),
        tooltip: 'Edit',
        onPressed: () async {
          final apiKey = await showTextInputDialog(
            context,
            title: const Text('Set API Key'),
            text: apiKeyTextFieldController.text,
            hintText:
                'Generate keys in your profile in the Nucleus One web app.',
          );
          if (apiKey != null) {
            apiKeyTextFieldController.text = apiKey;
            /* TODO(apn): refresh data */
          }
        },
      ),
      item2: SelectionArea(
        child: TextField(
          controller: apiKeyTextFieldController,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'API Key',
            hintText: 'Use the edit button to set your API key.',
          ),
        ),
      ),
    );
  }

  TableRow _refreshDataRow() {
    return _buildTableRow(
      item2: TextButton(
        onPressed: () {},
        child: const Text('⟳ Refresh organization and project lists'),
      ),
    );
  }

  TableRow _orgDropdownRow() {
    return _buildTableRow(
      item2: DropdownButton(
        value: orgValue,
        hint: const Text('Select Organization'),
        items: orgList
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            orgValue = value;
          });
        },
      ),
    );
  }

  TableRow _projectDropdownRow() {
    return _buildTableRow(
      item2: DropdownButton(
        value: projectValue,
        hint: const Text('Select Project'),
        items: projectList
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            projectValue = value;
          });
        },
      ),
    );
  }

  TableRow _destinationControlsRow(BuildContext context) {
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

  TableRow _maxConcurrentDownloadsControlsRow(BuildContext context) {
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

  Table _settingsTable(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
      },
      textBaseline: TextBaseline.alphabetic,
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      children: [
        _apiKeyControlsRow(context),
        _spacerRow(height: Insets.compSmall),
        _refreshDataRow(),
        _spacerRow(height: Insets.compSmall),
        _orgDropdownRow(),
        _spacerRow(height: Insets.compSmall),
        _projectDropdownRow(),
        _spacerRow(height: Insets.compSmall),
        _destinationControlsRow(context),
        _spacerRow(height: Insets.compSmall),
        _optionControlsRow(),
        _spacerRow(height: Insets.compSmall),
        _maxConcurrentDownloadsControlsRow(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          primary: true,
          child: Container(
            margin: const EdgeInsets.all(Insets.compLarge).copyWith(top: 12),
            child: Column(
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
                        _introText(context),
                        const SizedBox(height: Insets.compSmall),
                        _settingsTable(context),
                        const SizedBox(height: Insets.compLarge),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Export Documents'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
