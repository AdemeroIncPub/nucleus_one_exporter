import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod/riverpod.dart';

import '../../application/providers.dart';
import '../../application/services/user_orgs_summary_service.dart';
import '../cli.dart';
import '../providers.dart';

class InfoCommand extends Command<void> {
  InfoCommand({
    Future<UserOrgsSummary>? userOrgsSummary,
    Logger? logger,
  })  : _userOrgsSummary = userOrgsSummary ??
            GetIt.I<ProviderContainer>().read(userOrgsSummaryProvider.future),
        _logger =
            logger ?? GetIt.I.get<ProviderContainer>().read(loggerProvider);

  final Future<UserOrgsSummary> _userOrgsSummary;
  final Logger _logger;

  @override
  ArgParser get argParser => _argParser;
  final _argParser = ArgParser(usageLineLength: usageLineLength);

  @override
  String get name => 'info';

  @override
  String get description =>
      'Get organization and project info (including IDs).';

  @override
  Future<void> run() async {
    final summary = await _userOrgsSummary;
    final printer = InfoPrinter(_logger);
    printer.printInfo(summary);
  }
}

class InfoPrinter {
  InfoPrinter(Logger logger) : _logger = logger;

  void printInfo(UserOrgsSummary summary) {
    _printOrgCount(summary.orgInfos.length);
    for (final org in summary.orgInfos) {
      _printOrg(
          id: org.id, name: org.name, projectCount: org.projectInfos.length);
      for (final project in org.projectInfos) {
        _printProject(
            id: project.id, name: project.name, docCount: project.docCount);
      }
    }
  }

  final Logger _logger;

  void _printOrgCount(int count) {
    _logger.stdout('Organizations: $count');
  }

  void _printOrg(
      {required String id, required String name, required int projectCount}) {
    _logger.stdout('- Organization');
    _logger.stdout('  Name: $name');
    _logger.stdout('  ID: $id');
    _logger.stdout('  Projects: $projectCount');
  }

  void _printProject(
      {required String id, required String name, required int docCount}) {
    _logger.stdout('  - Project');
    _logger.stdout('    Name: $name');
    _logger.stdout('    ID: $id');
    _logger.stdout('    Documents: $docCount');
  }
}
