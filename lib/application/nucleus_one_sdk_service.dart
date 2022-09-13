import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;

class NucleusOneSdkService {
  NucleusOneSdkService({required this.n1App});

  n1.NucleusOneApp n1App;

  // Future<List<n1.OrganizationProject>> getOrganizationProjects({
  //   required String organizationId,
  // }) async {
  //   return (await _n1App
  //           .organization(organizationId)
  //           // todo(apn): (getAll: true) causes 0 results. Need to either fix
  //           // the api call or change logic to gather all results via paging.
  //           // .getProjects(organizationId: organizationId, getAll: true))
  //           .getProjects(organizationId: organizationId))
  //       .results
  //       .items;
  // }

  // todo(apn): should return nullable
  // Future<n1.OrganizationProject> getOrganizationProject({
  //   required String organizationId,
  //   required String projectId,
  // }) async {
  //   return (await getOrganizationProjects(organizationId: organizationId))
  //       .firstWhere((p) => p.id == projectId);
  // }

  Future<List<n1.UserOrganization>> getUserOrganizations() async {
    return (await n1App.users().getOrganizations()).items;
  }

  // todo(apn): should return nullable
  Future<n1.UserOrganization> getUserOrganization({
    required String organizationId,
  }) async {
    return (await getUserOrganizations())
        .firstWhere((o) => o.organizationID == organizationId);
  }

  Future<List<n1.UserOrganizationProject>> getUserProjects({
    required String organizationId,
  }) async {
    return (await n1App.users().getProjects(organizationId: organizationId))
        .items;
  }

  // todo(apn): should return nullable
  Future<n1.UserOrganizationProject> getUserProject({
    required String organizationId,
    required String projectId,
  }) async {
    return (await getUserProjects(organizationId: organizationId))
        .firstWhere((p) => p.projectID == projectId);
  }

  Future<int> getDocumentCount({
    required String organizationId,
    required String projectId,
    required bool ignoreInbox,
    required bool ignoreRecycleBin,
  }) {
    return n1App
        .organization(organizationId)
        .project(projectId)
        .getDocumentCount(ignoreInbox, ignoreRecycleBin);
  }

  Future<n1.QueryResult<n1.DocumentCollection>> getDocuments({
    required String orgId,
    required String projectId,
    String? cursor,
  }) {
    final project = n1App.organization(orgId).project(projectId);
    return project.getDocuments(showAll: true, cursor: cursor);
  }

  Future<n1.DocumentContentPackage> getDocumentContentPackage(n1.Document doc) {
    final project =
        n1App.organization(doc.organizationID).project(doc.projectID);
    return project.document(doc.documentID).getDocumentContentPackage();
  }
}
