import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;

class InfoCommand extends Command<void> {
  @override
  String get name => 'info';
  @override
  String get description => 'Get organization and project IDs.';

  @override
  Future<void> run() async {
    final gi = GetIt.instance;
    final n1App = gi<n1.NucleusOneApp>();
    final printer = InfoPrinter();

    final orgs = (await n1App.users().getOrganizations()).items;
    printer.printOrgCount(orgs.length);
    for (final org in orgs) {
      // TODO(apn): Not returning projects?
      final projects =
          (await n1App.users().getProjects(organizationId: org.organizationID))
              .items;

      printer.printOrg(
          id: org.organizationID,
          name: org.organizationName,
          projectCount: projects.length);

      for (final project in projects) {
        final docCount = await n1App
            .organization(org.organizationID)
            .project(project.projectID)
            .getDocumentCount(true, true);

        printer.printProject(
            id: project.projectID,
            name: project.projectName,
            docCount: docCount);
      }
    }
  }
}

class InfoPrinter {
  void printOrgCount(int count) {
    print('Organizations: $count');
  }

  void printOrg(
      {required String id, required String name, required int projectCount}) {
    print('- Organization');
    print('  Name: $name');
    print('  ID: $id');
    print('  Projects: $projectCount');
  }

  void printProject(
      {required String id, required String name, required int docCount}) {
    print('  - Project');
    print('    Name: $name');
    print('    ID: $id');
    print('    Documents: $docCount');
  }
}
