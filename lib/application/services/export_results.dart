import 'package:freezed_annotation/freezed_annotation.dart';

part 'export_results.freezed.dart';

@freezed
class ExportResults with _$ExportResults {
  const factory ExportResults(
    DateTime started, {
    @Default(0) int totalAttempted,
    @Default(0) int totalExported,
    @Default(0) int savedAsCopy,
    @Default(0) int skippedAlreadyExists,
    @Default(0) int skippedUnknownFailure,
    DateTime? finished,
  }) = _ExportResults;

  const ExportResults._();

  // Adds counts, but keeps this itmes [started] and [finished].
  ExportResults add(ExportResults other) {
    return copyWith(
      totalAttempted: totalAttempted + other.totalAttempted,
      totalExported: totalExported + other.totalExported,
      savedAsCopy: savedAsCopy + other.savedAsCopy,
      skippedAlreadyExists: skippedAlreadyExists + other.skippedAlreadyExists,
      skippedUnknownFailure:
          skippedUnknownFailure + other.skippedUnknownFailure,
    );
  }

  ExportResults docExported() => copyWith(
      totalAttempted: totalAttempted + 1, totalExported: totalExported + 1);

  ExportResults docSavedAsCopy() => copyWith(
      totalAttempted: totalAttempted + 1,
      totalExported: totalExported + 1,
      savedAsCopy: savedAsCopy + 1);

  ExportResults docSkippedAlreadyExists() => copyWith(
      totalAttempted: totalAttempted + 1,
      skippedAlreadyExists: skippedAlreadyExists + 1);

  ExportResults docSkippedUnknownFailure() => copyWith(
      totalAttempted: totalAttempted + 1,
      skippedUnknownFailure: skippedUnknownFailure + 1);

  ExportResults setFinished() => copyWith(finished: DateTime.now());

  Duration? get elapsed =>
      (finished ?? DateTime.now()).difference(started).abs();
}
