import 'package:get_it/get_it.dart';
import 'package:riverpod/riverpod.dart';

import '../nucleus_one_sdk_service.dart';
import '../providers.dart';

class UserOrgsSummaryService {
  UserOrgsSummaryService({Future<NucleusOneSdkService>? n1Sdk})
      : _n1Sdk = n1Sdk ??
            GetIt.I<ProviderContainer>()
                .read(nucleusOneSdkServiceProvider.future);

  final Future<NucleusOneSdkService> _n1Sdk;

  Future<UserOrgsSummary> getSummary() async {
    // Get Organizations.
    final n1Sdk = await _n1Sdk;
    final orgs = await n1Sdk.getUserOrganizations();
    final info = UserOrgsSummary();
    for (final org in orgs) {
      final orgInfo =
          OrganizationInfo(id: org.organizationID, name: org.organizationName);

      // Get Projects.
      // final projects =
      //     await n1Sdk.getUserProjects(organizationId: org.organizationID);
      final projects = await n1Sdk.getOrganizationProjects(
          organizationId: org.organizationID);
      for (final project in projects) {
        // Get Document count.
        final docCount = await n1Sdk.getDocumentCount(
            organizationId: org.organizationID,
            projectId: project.id,
            ignoreInbox: true,
            ignoreRecycleBin: true);
        final projectInfo = ProjectInfo(
          id: project.id,
          name: project.name,
          docCount: docCount,
        );

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
