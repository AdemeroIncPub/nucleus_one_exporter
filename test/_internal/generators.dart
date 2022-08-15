import 'package:glados/glados.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;

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
                x.project.projectID = userOrganization.organizationID;
                x.project.projectName = userOrganization.organizationName;
              }
              return MyUserOrgAndProjectsWithDocCount(
                  userOrganization, myUserOrgProjectWithDocCount);
            },
          );

  Generator<MyUserOrgProjectWithDocCount> get _myUserOrgProjectWithDocCount =>
      any.combine2(
        userOrganizationProject,
        any.positiveIntOrZero,
        (
          n1.UserOrganizationProject userOrganizationProject,
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

  Generator<n1.UserOrganizationProject> get userOrganizationProject =>
      any.combine8(
        any.list(printableAscii),
        any.printableAscii,
        any.printableAsciiWithSpace,
        any.printableAscii,
        any.printableAscii,
        any.bool,
        any.printableAsciiWithSpace,
        any.printableAscii,
        (
          List<String> assignmentTypes,
          String organizationID,
          String organizationName,
          String projectAccessType,
          String projectID,
          bool projectIsDisabled,
          String projectName,
          String userEmail,
        ) {
          return n1.UserOrganizationProject(
            assignmentTypes: assignmentTypes,
            hasAssignment: assignmentTypes.isNotEmpty,
            organizationID: organizationID,
            organizationName: organizationName,
            projectAccessType: projectAccessType,
            projectID: projectID,
            projectIsDisabled: projectIsDisabled,
            projectName: projectName,
            userEmail: userEmail,
          );
        },
      );
}
