import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import '../../commands/info.dart';
import '../cli.dart';

class InfoCommand extends Command<void> {
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
    final info = await getInfo();
    final printer = InfoPrinter();
    printer.printInfo(info);
  }
}

class InfoPrinter {
  void printInfo(InfoCommandInfo info) {
    _printOrgCount(info.orgInfos.length);
    for (final org in info.orgInfos) {
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
