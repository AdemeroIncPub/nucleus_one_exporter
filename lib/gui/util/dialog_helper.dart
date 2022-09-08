import 'package:flutter/material.dart';

Future<String?> showTextInputDialog(
  BuildContext context, {
  String? text,
  Widget? title,
  String? labelText,
  String? hintText,
}) async {
  final textFieldController = TextEditingController();
  textFieldController.text = text ?? '';

  void submitHandler(BuildContext context, String text) {
    Navigator.pop(context, textFieldController.text);
  }

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title,
        content: TextField(
          autofocus: true,
          controller: textFieldController,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
          ),
          onSubmitted: (value) => submitHandler(context, value),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () => submitHandler(context, textFieldController.text),
          ),
        ],
      );
    },
  );
}
