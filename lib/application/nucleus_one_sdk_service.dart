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

  Future<List<n1.OrganizationProject>> getOrganizationProjects({
    required String organizationId,
  }) async {
    return (await _n1App
            .organization(organizationId)
            .getProjects(organizationId: organizationId, getAll: true))
        .results
        .items;
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
}
