import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';

import '../../application/services/user_orgs_summary_service.dart';
import '../cli.dart';

class InfoCommand extends Command<void> {
  InfoCommand({UserOrgsSummaryService? userOrgsSummaryService})
      : _userOrgsSummaryService =
            userOrgsSummaryService ?? GetIt.I<UserOrgsSummaryService>();

  final UserOrgsSummaryService _userOrgsSummaryService;

  @override
  ArgParser get argParser => _argParser;
  final _argParser = ArgParser(usageLineLength: usageLineLength);

  @override
  String get name => 'info';

  @override
  String get description =>
      'Get organization and project info (including IDs).';

  @override
  Future<void> run() async {
    final summary = await _userOrgsSummaryService.getSummary();
    final printer = InfoPrinter();
    printer.printInfo(summary);
  }
}

class InfoPrinter {
  void printInfo(UserOrgsSummary summary) {
    _printOrgCount(summary.orgInfos.length);
    for (final org in summary.orgInfos) {
      _printOrg(
          id: org.id, name: org.name, projectCount: org.projectInfos.length);
      for (final project in org.projectInfos) {
        _printProject(
            id: project.id, name: project.name, docCount: project.docCount);
      }
    }
  }

  void _printOrgCount(int count) {
    print('Organizations: $count');
  }

  void _printOrg(
      {required String id, required String name, required int projectCount}) {
    print('- Organization');
    print('  Name: $name');
    print('  ID: $id');
    print('  Projects: $projectCount');
  }

  void _printProject(
      {required String id, required String name, required int docCount}) {
    print('  - Project');
    print('    Name: $name');
    print('    ID: $id');
    print('    Documents: $docCount');
  }
}
