import 'package:collection/collection.dart';
import 'package:dartx/dartx.dart';
import 'package:glados/glados.dart';
import 'package:mocktail/mocktail.dart' as mt;
import 'package:nucleus_one_exporter/application/services/user_orgs_summary_service.dart';

import '../../../../_internal/generators.dart';
import '../../../../_internal/mocks.dart';

void main() {
  Glados(any.list(any.myUserOrgAndProjectsWithDocCount)).test(
    'getSummary returns correct UserOrgsSummary',
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
            .when(() =>
                mockNucleusOneSdkService.getUserProjects(organizationId: orgId))
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

      final sut =
          UserOrgsSummaryService(n1Sdk: Future.value(mockNucleusOneSdkService));

      // Act
      final info = await sut.getSummary();

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

      mt.resetMocktailState();
    },
  );
}
