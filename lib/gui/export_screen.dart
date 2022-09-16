import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/services/export_documents_args.dart';

class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key, required this.validArgs});

  final ValidatedExportDocumentsArgs validArgs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
