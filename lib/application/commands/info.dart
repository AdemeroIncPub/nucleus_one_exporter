import 'dart:async';

import 'package:get_it/get_it.dart';

import '../nucleus_one_sdk_service.dart';

Future<InfoCommandInfo> getInfo({NucleusOneSdkService? n1Sdk}) async {
  final n1Sdk_ = n1Sdk ?? GetIt.I<NucleusOneSdkService>();

  // Get Organizations.
  final orgs = await n1Sdk_.getUserOrganizations();
  final info = InfoCommandInfo();
  for (final org in orgs) {
    final orgInfo =
        OrganizationInfo(id: org.organizationID, name: org.organizationName);

    // Get Projects.
    final projects = await n1Sdk_.getUserOrganizationProjects(
        organizationId: org.organizationID);
    for (final project in projects) {
      // Get Document count.
      final docCount = await n1Sdk_.getDocumentCount(
          organizationId: org.organizationID,
          projectId: project.projectID,
          ignoreInbox: true,
          ignoreRecycleBin: true);
      final projectInfo = ProjectInfo(
          id: project.projectID, name: project.projectName, docCount: docCount);

      orgInfo.projectInfos.add(projectInfo);
    }
    info.orgInfos.add(orgInfo);
  }

  return info;
}

class InfoCommandInfo {
  final List<OrganizationInfo> orgInfos = [];
}

class OrganizationInfo {
  OrganizationInfo({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
  final List<ProjectInfo> projectInfos = [];
}

class ProjectInfo {
  ProjectInfo({
    required this.id,
    required this.name,
    this.docCount = 0,
  });

  final String id;
  final String name;
  final int docCount;
}
