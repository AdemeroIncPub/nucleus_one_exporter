import 'package:mocktail/mocktail.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:nucleus_one_exporter/application/nucleus_one_sdk_service.dart';

class MockNucleusOneApp extends Mock implements n1.NucleusOneApp {}

class MockNucleusOneSdkService extends Mock implements NucleusOneSdkService {}
