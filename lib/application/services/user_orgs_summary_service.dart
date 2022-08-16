import 'package:get_it/get_it.dart';

import '../nucleus_one_sdk_service.dart';

class UserOrgsSummaryService {
  UserOrgsSummaryService({NucleusOneSdkService? n1Sdk})
      : _n1Sdk = n1Sdk ?? GetIt.I<NucleusOneSdkService>();

  final NucleusOneSdkService _n1Sdk;

  Future<UserOrgsSummary> getSummary() async {
    // Get Organizations.
    final orgs = await _n1Sdk.getUserOrganizations();
    final info = UserOrgsSummary();
    for (final org in orgs) {
      final orgInfo =
          OrganizationInfo(id: org.organizationID, name: org.organizationName);

      // Get Projects.
      final projects = await _n1Sdk.getUserOrganizationProjects(
          organizationId: org.organizationID);
      for (final project in projects) {
        // Get Document count.
        final docCount = await _n1Sdk.getDocumentCount(
            organizationId: org.organizationID,
            projectId: project.projectID,
            ignoreInbox: true,
            ignoreRecycleBin: true);
        final projectInfo = ProjectInfo(
            id: project.projectID,
            name: project.projectName,
            docCount: docCount);

        orgInfo.projectInfos.add(projectInfo);
      }
      info.orgInfos.add(orgInfo);
    }

    return info;
  }
}

class UserOrgsSummary {
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
