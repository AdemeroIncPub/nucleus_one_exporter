import 'package:glados/glados.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:tuple/tuple.dart';

class MyUserOrgAndProjectsWithDocCount {
  MyUserOrgAndProjectsWithDocCount(this.org, this.projectsWithDocCount);

  n1.UserOrganization org;
  List<MyUserOrgProjectWithDocCount> projectsWithDocCount;
}

class MyUserOrgProjectWithDocCount {
  MyUserOrgProjectWithDocCount(this.project, this.docCount);

  n1.UserOrganizationProject project;
  int docCount;
}

extension MyGenerators on Any {
  static const _printableAscii =
      r'''!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ'''
      r'''[\]^_`abcdefghijklmnopqrstuvwxyz{|}~''';
  static const _printableAsciiWithSpace = ' $_printableAscii';

  Generator<String> get printableAscii => any.stringOf(_printableAscii);

  Generator<String> get printableAsciiWithSpace =>
      any.stringOf(_printableAsciiWithSpace);

  Generator<MyUserOrgAndProjectsWithDocCount>
      get myUserOrgAndProjectsWithDocCount => any.combine2(
            userOrganization,
            // List size limited to reduce test time.
            any.listWithLengthInRange(0, 4, _myUserOrgProjectWithDocCount),
            (
              n1.UserOrganization userOrganization,
              List<MyUserOrgProjectWithDocCount> myUserOrgProjectWithDocCount,
            ) {
              for (final x in myUserOrgProjectWithDocCount) {
                x.project.organizationID = userOrganization.organizationID;
              }
              return MyUserOrgAndProjectsWithDocCount(
                  userOrganization, myUserOrgProjectWithDocCount);
            },
          );

  Generator<MyUserOrgProjectWithDocCount> get _myUserOrgProjectWithDocCount =>
      any.combine2(
        userOrganizationProject,
        any.positiveIntOrZero,
        MyUserOrgProjectWithDocCount.new,
      );

  Generator<n1.UserOrganization> get userOrganization => any.combine6(
        any.list(printableAscii),
        any.bool,
        any.bool,
        printableAscii,
        printableAsciiWithSpace,
        printableAscii,
        (
          List<String> assignmentTypes,
          bool hasAssignment,
          bool isOrganizationMember,
          String organizationID,
          String organizationName,
          String userEmail,
        ) {
          return n1.UserOrganization(
            assignmentTypes: assignmentTypes,
            hasAssignment: hasAssignment,
            isOrganizationMember: isOrganizationMember,
            organizationID: organizationID,
            organizationName: organizationName,
            userEmail: userEmail,
          );
        },
      );

  Generator<n1.UserOrganizationProject> get userOrganizationProject =>
      any.combine2(
        any.combine7(
          any.list(printableAscii),
          any.bool,
          any.printableAscii,
          any.printableAsciiWithSpace,
          any.printableAscii,
          any.printableAscii,
          any.bool,
          (
            List<String> assignmentTypes,
            bool hasAssignment,
            String organizationID,
            String organizationName,
            String projectAccessType,
            String projectID,
            bool projectIsDisabled,
          ) {
            return Tuple7(
              assignmentTypes,
              hasAssignment,
              organizationID,
              organizationName,
              projectAccessType,
              projectID,
              projectIsDisabled,
            );
          },
        ),
        any.combine2(
          any.printableAsciiWithSpace,
          any.printableAscii,
          (
            String projectName,
            String userEmail,
          ) {
            return Tuple2(
              projectName,
              userEmail,
            );
          },
        ),
        (
          Tuple7<List<String>, bool, String, String, String, String, bool> a,
          Tuple2<String, String> b,
        ) {
          return n1.UserOrganizationProject(
            assignmentTypes: a.item1,
            hasAssignment: a.item2,
            organizationID: a.item3,
            organizationName: a.item4,
            projectAccessType: a.item5,
            projectID: a.item6,
            projectIsDisabled: a.item7,
            projectName: b.item1,
            userEmail: b.item2,
          );
        },
      );

  Generator<n1.OrganizationProject> get organizationProject => any.combine2(
        any.combine7(
          any.printableAscii,
          any.printableAscii,
          any.printableAscii,
          any.printableAsciiWithSpace,
          any.printableAscii,
          any.bool,
          any.printableAscii,
          (
            String accessType,
            String createdByUserEmail,
            String createdByUserID,
            String createdByUserName,
            String createdOn,
            bool disabled,
            String id,
          ) {
            return Tuple7(
              accessType,
              createdByUserEmail,
              createdByUserID,
              createdByUserName,
              createdOn,
              disabled,
              id,
            );
          },
        ),
        any.combine7(
          any.bool,
          any.printableAsciiWithSpace,
          any.printableAscii,
          any.printableAscii,
          any.printableAscii,
          any.printableAscii,
          any.printableAscii,
          (
            bool isMarkedForPurge,
            String name,
            String organizationID,
            String purgeMarkedByUserEmail,
            String purgeMarkedByUserID,
            String purgeMarkedByUserName,
            String purgeMarkedOn,
          ) {
            return Tuple7(
              isMarkedForPurge,
              name,
              organizationID,
              purgeMarkedByUserEmail,
              purgeMarkedByUserID,
              purgeMarkedByUserName,
              purgeMarkedOn,
            );
          },
        ),
        (
          Tuple7<String, String, String, String, String, bool, String> a,
          Tuple7<bool, String, String, String, String, String, String> b,
        ) {
          return n1.OrganizationProject(
            accessType: a.item1,
            createdByUserEmail: a.item2,
            createdByUserID: a.item3,
            createdByUserName: a.item4,
            createdOn: a.item5,
            disabled: a.item6,
            id: a.item7,
            isMarkedForPurge: b.item1,
            name: b.item2,
            nameLower: b.item2.toLowerCase(),
            organizationID: b.item3,
            purgeMarkedByUserEmail: b.item4,
            purgeMarkedByUserID: b.item5,
            purgeMarkedByUserName: b.item6,
            purgeMarkedOn: b.item7,
          );
        },
      );
}
