import 'package:collection/collection.dart';
import 'package:dartx/dartx.dart';
import 'package:get_it/get_it.dart';
import 'package:glados/glados.dart';
import 'package:mocktail/mocktail.dart' as mt;
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:nucleus_one_exporter/application/commands/info.dart';

import '../../../_internal/generators.dart';
import '../../../_internal/mocks.dart';

void main() {
  setUp(() {
    final n1App = MockNucleusOneApp();
    GetIt.I.registerSingleton<n1.NucleusOneApp>(n1App);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  Glados(any.list(any.myUserOrgAndProjectsWithDocCount)).test(
    'getInfo returns correct InfoCommandInfo',
    (myUserOrgAndProjectsWithDocCounts) async {
      // Arrange
      // Setup orgs
      // Org IDs must be distinct - filter generated dups.
      myUserOrgAndProjectsWithDocCounts = myUserOrgAndProjectsWithDocCounts
          .distinctBy((e) => e.org.organizationID)
          .toList();

      final mockNucleusOneSdkService = MockNucleusOneSdkService();
      final orgs = myUserOrgAndProjectsWithDocCounts.map((e) => e.org).toList();
      mt
          .when(() => mockNucleusOneSdkService.getUserOrganizations())
          .thenAnswer((_) async => orgs);

      // Setup projects
      for (final myUoapwdc in myUserOrgAndProjectsWithDocCounts) {
        final orgId = myUoapwdc.org.organizationID;
        // Project IDs must be distinct - filter generated dups.
        myUoapwdc.projectsWithDocCount = myUoapwdc.projectsWithDocCount
            .distinctBy((e) => e.project.projectID)
            .toList();

        final projects =
            myUoapwdc.projectsWithDocCount.map((e) => e.project).toList();
        mt
            .when(() => mockNucleusOneSdkService.getUserOrganizationProjects(
                organizationId: orgId))
            .thenAnswer((_) async => projects);

        // Setup doc counts
        for (final pwdc in myUoapwdc.projectsWithDocCount) {
          final projectId = pwdc.project.projectID;
          mt
              .when(() => mockNucleusOneSdkService.getDocumentCount(
                  organizationId: orgId,
                  projectId: projectId,
                  ignoreInbox: true,
                  ignoreRecycleBin: true))
              .thenAnswer((_) async => pwdc.docCount);
        }
      }

      // Act
      final info = await getInfo(n1Sdk: mockNucleusOneSdkService);

      // Assert
      expect(myUserOrgAndProjectsWithDocCounts.length, info.orgInfos.length);
      info.orgInfos.forEachIndexed((i, orgInfo) {
        final myUoapwdc = myUserOrgAndProjectsWithDocCounts[i];
        expect(orgInfo.id, myUoapwdc.org.organizationID);
        expect(orgInfo.name, myUoapwdc.org.organizationName);

        expect(
            orgInfo.projectInfos.length, myUoapwdc.projectsWithDocCount.length);
        orgInfo.projectInfos.forEachIndexed((j, projectInfo) {
          final pwdc = myUoapwdc.projectsWithDocCount[j];
          expect(pwdc.project.projectID, projectInfo.id);
          expect(pwdc.project.projectName, projectInfo.name);
          expect(pwdc.docCount, projectInfo.docCount);
        });
      });
    },
  );
}
