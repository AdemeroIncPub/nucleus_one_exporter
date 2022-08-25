import 'package:dartz/dartz.dart';
import 'package:glados/glados.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;

class MyUserOrgAndProjectsWithDocCount {
  MyUserOrgAndProjectsWithDocCount(this.org, this.projectsWithDocCount);

  n1.UserOrganization org;
  List<MyUserOrgProjectWithDocCount> projectsWithDocCount;
}

class MyUserOrgProjectWithDocCount {
  MyUserOrgProjectWithDocCount(this.project, this.docCount);

  n1.OrganizationProject project;
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
        organizationProject,
        any.positiveIntOrZero,
        (
          n1.OrganizationProject userOrganizationProject,
          int docCount,
        ) =>
            MyUserOrgProjectWithDocCount(userOrganizationProject, docCount),
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

  Generator<n1.OrganizationProject> get organizationProject => any.combine2(
        any.combine10(
          any.printableAscii,
          any.printableAscii,
          any.printableAscii,
          any.printableAsciiWithSpace,
          any.printableAscii,
          any.bool,
          any.printableAscii,
          any.bool,
          any.printableAsciiWithSpace,
          any.printableAscii,
          (
            String accessType,
            String createdByUserEmail,
            String createdByUserID,
            String createdByUserName,
            String createdOn,
            bool disabled,
            String id,
            bool isMarkedForPurge,
            String name,
            String organizationID,
          ) {
            return Tuple10(
              accessType,
              createdByUserEmail,
              createdByUserID,
              createdByUserName,
              createdOn,
              disabled,
              id,
              isMarkedForPurge,
              name,
              organizationID,
            );
          },
        ),
        any.combine4(
          any.printableAscii,
          any.printableAscii,
          any.printableAscii,
          any.printableAscii,
          (
            String purgeMarkedByUserEmail,
            String purgeMarkedByUserID,
            String purgeMarkedByUserName,
            String purgeMarkedOn,
          ) {
            return Tuple4(
              purgeMarkedByUserEmail,
              purgeMarkedByUserID,
              purgeMarkedByUserName,
              purgeMarkedOn,
            );
          },
        ),
        (
          Tuple10<String, String, String, String, String, bool, String, bool,
                  String, String>
              a,
          Tuple4<String, String, String, String> b,
        ) {
          return n1.OrganizationProject(
            accessType: a.value1,
            createdByUserEmail: a.value2,
            createdByUserID: a.value3,
            createdByUserName: a.value4,
            createdOn: a.value5,
            disabled: a.value6,
            id: a.value7,
            isMarkedForPurge: a.value8,
            name: a.value9,
            nameLower: a.value9.toLowerCase(),
            organizationID: a.value10,
            purgeMarkedByUserEmail: b.value1,
            purgeMarkedByUserID: b.value2,
            purgeMarkedByUserName: b.value3,
            purgeMarkedOn: b.value4,
          );
        },
      );
}
