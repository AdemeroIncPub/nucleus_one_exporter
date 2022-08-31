import 'package:get_it/get_it.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;

class NucleusOneSdkService {
  NucleusOneSdkService({n1.NucleusOneApp? n1App});

  n1.NucleusOneApp? n1App;

  // It's hard to know when n1.NucleusOneApp singleton might be reset (changed
  // api key), so this will get the current one each call.
  n1.NucleusOneApp get _n1App => n1App ?? GetIt.I<n1.NucleusOneApp>();

  Future<List<n1.UserOrganization>> getUserOrganizations() async {
    return (await _n1App.users().getOrganizations()).items;
  }

  Future<n1.UserOrganization> getUserOrganization({
    required String organizationId,
  }) async {
    return (await getUserOrganizations())
        .firstWhere((o) => o.organizationID == organizationId);
  }

  Future<List<n1.OrganizationProject>> getOrganizationProjects({
    required String organizationId,
  }) async {
    return (await _n1App
            .organization(organizationId)
            // todo(apn): (getAll: true) causes 0 results. Need to either fix
            // the api call or change logic to gather all results via paging.
            // .getProjects(organizationId: organizationId, getAll: true))
            .getProjects(organizationId: organizationId))
        .results
        .items;
  }

  Future<n1.OrganizationProject> getProject({
    required String organizationId,
    required String projectId,
  }) async {
    return (await getOrganizationProjects(organizationId: organizationId))
        .firstWhere((p) => p.id == projectId);
  }

  Future<int> getDocumentCount({
    required String organizationId,
    required String projectId,
    required bool ignoreInbox,
    required bool ignoreRecycleBin,
  }) {
    return _n1App
        .organization(organizationId)
        .project(projectId)
        .getDocumentCount(ignoreInbox, ignoreRecycleBin);
  }

  Future<n1.QueryResult<n1.DocumentCollection>> getDocuments({
    required String orgId,
    required String projectId,
    String? cursor,
  }) {
    final project = _n1App.organization(orgId).project(projectId);
    return project.getDocuments(showAll: true, cursor: cursor);
  }

  Future<n1.DocumentContentPackage> getDocumentContentPackage(n1.Document doc) {
    final project =
        _n1App.organization(doc.organizationID).project(doc.projectID);
    return project.document(doc.documentID).getDocumentContentPackage();
  }
}
