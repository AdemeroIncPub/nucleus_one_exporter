// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'export_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ExportEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)
        beginExport,
    required TResult Function(String docId, String n1Path) docExportAttempt,
    required TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)
        docExported,
    required TResult Function(String docId, String n1Path, String localPath)
        docSkippedAlreadyExists,
    required TResult Function(String docId, String n1Path)
        docSkippedUnknownFailure,
    required TResult Function(
            Either<List<ExportFailure>, ExportResults> results)
        exportFinished,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeginExport value) beginExport,
    required TResult Function(DocExportAttempt value) docExportAttempt,
    required TResult Function(DocExported value) docExported,
    required TResult Function(DocSkippedAlreadyExists value)
        docSkippedAlreadyExists,
    required TResult Function(DocSkippedUnknownFailure value)
        docSkippedUnknownFailure,
    required TResult Function(ExportFinished value) exportFinished,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExportEventCopyWith<$Res> {
  factory $ExportEventCopyWith(
          ExportEvent value, $Res Function(ExportEvent) then) =
      _$ExportEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$ExportEventCopyWithImpl<$Res> implements $ExportEventCopyWith<$Res> {
  _$ExportEventCopyWithImpl(this._value, this._then);

  final ExportEvent _value;
  // ignore: unused_field
  final $Res Function(ExportEvent) _then;
}

/// @nodoc
abstract class _$$BeginExportCopyWith<$Res> {
  factory _$$BeginExportCopyWith(
          _$BeginExport value, $Res Function(_$BeginExport) then) =
      __$$BeginExportCopyWithImpl<$Res>;
  $Res call(
      {String orgId,
      String orgName,
      String projectId,
      String projectName,
      String localPath,
      int docCount});
}

/// @nodoc
class __$$BeginExportCopyWithImpl<$Res> extends _$ExportEventCopyWithImpl<$Res>
    implements _$$BeginExportCopyWith<$Res> {
  __$$BeginExportCopyWithImpl(
      _$BeginExport _value, $Res Function(_$BeginExport) _then)
      : super(_value, (v) => _then(v as _$BeginExport));

  @override
  _$BeginExport get _value => super._value as _$BeginExport;

  @override
  $Res call({
    Object? orgId = freezed,
    Object? orgName = freezed,
    Object? projectId = freezed,
    Object? projectName = freezed,
    Object? localPath = freezed,
    Object? docCount = freezed,
  }) {
    return _then(_$BeginExport(
      orgId: orgId == freezed
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      orgName: orgName == freezed
          ? _value.orgName
          : orgName // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: projectId == freezed
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      projectName: projectName == freezed
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      localPath: localPath == freezed
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String,
      docCount: docCount == freezed
          ? _value.docCount
          : docCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BeginExport implements BeginExport {
  const _$BeginExport(
      {required this.orgId,
      required this.orgName,
      required this.projectId,
      required this.projectName,
      required this.localPath,
      required this.docCount});

  @override
  final String orgId;
  @override
  final String orgName;
  @override
  final String projectId;
  @override
  final String projectName;
  @override
  final String localPath;
  @override
  final int docCount;

  @override
  String toString() {
    return 'ExportEvent.beginExport(orgId: $orgId, orgName: $orgName, projectId: $projectId, projectName: $projectName, localPath: $localPath, docCount: $docCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeginExport &&
            const DeepCollectionEquality().equals(other.orgId, orgId) &&
            const DeepCollectionEquality().equals(other.orgName, orgName) &&
            const DeepCollectionEquality().equals(other.projectId, projectId) &&
            const DeepCollectionEquality()
                .equals(other.projectName, projectName) &&
            const DeepCollectionEquality().equals(other.localPath, localPath) &&
            const DeepCollectionEquality().equals(other.docCount, docCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(orgId),
      const DeepCollectionEquality().hash(orgName),
      const DeepCollectionEquality().hash(projectId),
      const DeepCollectionEquality().hash(projectName),
      const DeepCollectionEquality().hash(localPath),
      const DeepCollectionEquality().hash(docCount));

  @JsonKey(ignore: true)
  @override
  _$$BeginExportCopyWith<_$BeginExport> get copyWith =>
      __$$BeginExportCopyWithImpl<_$BeginExport>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)
        beginExport,
    required TResult Function(String docId, String n1Path) docExportAttempt,
    required TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)
        docExported,
    required TResult Function(String docId, String n1Path, String localPath)
        docSkippedAlreadyExists,
    required TResult Function(String docId, String n1Path)
        docSkippedUnknownFailure,
    required TResult Function(
            Either<List<ExportFailure>, ExportResults> results)
        exportFinished,
  }) {
    return beginExport(
        orgId, orgName, projectId, projectName, localPath, docCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
  }) {
    return beginExport?.call(
        orgId, orgName, projectId, projectName, localPath, docCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
    required TResult orElse(),
  }) {
    if (beginExport != null) {
      return beginExport(
          orgId, orgName, projectId, projectName, localPath, docCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeginExport value) beginExport,
    required TResult Function(DocExportAttempt value) docExportAttempt,
    required TResult Function(DocExported value) docExported,
    required TResult Function(DocSkippedAlreadyExists value)
        docSkippedAlreadyExists,
    required TResult Function(DocSkippedUnknownFailure value)
        docSkippedUnknownFailure,
    required TResult Function(ExportFinished value) exportFinished,
  }) {
    return beginExport(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
  }) {
    return beginExport?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
    required TResult orElse(),
  }) {
    if (beginExport != null) {
      return beginExport(this);
    }
    return orElse();
  }
}

abstract class BeginExport implements ExportEvent {
  const factory BeginExport(
      {required final String orgId,
      required final String orgName,
      required final String projectId,
      required final String projectName,
      required final String localPath,
      required final int docCount}) = _$BeginExport;

  String get orgId;
  String get orgName;
  String get projectId;
  String get projectName;
  String get localPath;
  int get docCount;
  @JsonKey(ignore: true)
  _$$BeginExportCopyWith<_$BeginExport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocExportAttemptCopyWith<$Res> {
  factory _$$DocExportAttemptCopyWith(
          _$DocExportAttempt value, $Res Function(_$DocExportAttempt) then) =
      __$$DocExportAttemptCopyWithImpl<$Res>;
  $Res call({String docId, String n1Path});
}

/// @nodoc
class __$$DocExportAttemptCopyWithImpl<$Res>
    extends _$ExportEventCopyWithImpl<$Res>
    implements _$$DocExportAttemptCopyWith<$Res> {
  __$$DocExportAttemptCopyWithImpl(
      _$DocExportAttempt _value, $Res Function(_$DocExportAttempt) _then)
      : super(_value, (v) => _then(v as _$DocExportAttempt));

  @override
  _$DocExportAttempt get _value => super._value as _$DocExportAttempt;

  @override
  $Res call({
    Object? docId = freezed,
    Object? n1Path = freezed,
  }) {
    return _then(_$DocExportAttempt(
      docId: docId == freezed
          ? _value.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String,
      n1Path: n1Path == freezed
          ? _value.n1Path
          : n1Path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DocExportAttempt implements DocExportAttempt {
  const _$DocExportAttempt({required this.docId, required this.n1Path});

  @override
  final String docId;
  @override
  final String n1Path;

  @override
  String toString() {
    return 'ExportEvent.docExportAttempt(docId: $docId, n1Path: $n1Path)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocExportAttempt &&
            const DeepCollectionEquality().equals(other.docId, docId) &&
            const DeepCollectionEquality().equals(other.n1Path, n1Path));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(docId),
      const DeepCollectionEquality().hash(n1Path));

  @JsonKey(ignore: true)
  @override
  _$$DocExportAttemptCopyWith<_$DocExportAttempt> get copyWith =>
      __$$DocExportAttemptCopyWithImpl<_$DocExportAttempt>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)
        beginExport,
    required TResult Function(String docId, String n1Path) docExportAttempt,
    required TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)
        docExported,
    required TResult Function(String docId, String n1Path, String localPath)
        docSkippedAlreadyExists,
    required TResult Function(String docId, String n1Path)
        docSkippedUnknownFailure,
    required TResult Function(
            Either<List<ExportFailure>, ExportResults> results)
        exportFinished,
  }) {
    return docExportAttempt(docId, n1Path);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
  }) {
    return docExportAttempt?.call(docId, n1Path);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
    required TResult orElse(),
  }) {
    if (docExportAttempt != null) {
      return docExportAttempt(docId, n1Path);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeginExport value) beginExport,
    required TResult Function(DocExportAttempt value) docExportAttempt,
    required TResult Function(DocExported value) docExported,
    required TResult Function(DocSkippedAlreadyExists value)
        docSkippedAlreadyExists,
    required TResult Function(DocSkippedUnknownFailure value)
        docSkippedUnknownFailure,
    required TResult Function(ExportFinished value) exportFinished,
  }) {
    return docExportAttempt(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
  }) {
    return docExportAttempt?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
    required TResult orElse(),
  }) {
    if (docExportAttempt != null) {
      return docExportAttempt(this);
    }
    return orElse();
  }
}

abstract class DocExportAttempt implements ExportEvent {
  const factory DocExportAttempt(
      {required final String docId,
      required final String n1Path}) = _$DocExportAttempt;

  String get docId;
  String get n1Path;
  @JsonKey(ignore: true)
  _$$DocExportAttemptCopyWith<_$DocExportAttempt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocExportedCopyWith<$Res> {
  factory _$$DocExportedCopyWith(
          _$DocExported value, $Res Function(_$DocExported) then) =
      __$$DocExportedCopyWithImpl<$Res>;
  $Res call(
      {String docId, String n1Path, String localPath, bool exportedAsCopy});
}

/// @nodoc
class __$$DocExportedCopyWithImpl<$Res> extends _$ExportEventCopyWithImpl<$Res>
    implements _$$DocExportedCopyWith<$Res> {
  __$$DocExportedCopyWithImpl(
      _$DocExported _value, $Res Function(_$DocExported) _then)
      : super(_value, (v) => _then(v as _$DocExported));

  @override
  _$DocExported get _value => super._value as _$DocExported;

  @override
  $Res call({
    Object? docId = freezed,
    Object? n1Path = freezed,
    Object? localPath = freezed,
    Object? exportedAsCopy = freezed,
  }) {
    return _then(_$DocExported(
      docId: docId == freezed
          ? _value.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String,
      n1Path: n1Path == freezed
          ? _value.n1Path
          : n1Path // ignore: cast_nullable_to_non_nullable
              as String,
      localPath: localPath == freezed
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String,
      exportedAsCopy: exportedAsCopy == freezed
          ? _value.exportedAsCopy
          : exportedAsCopy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DocExported implements DocExported {
  const _$DocExported(
      {required this.docId,
      required this.n1Path,
      required this.localPath,
      required this.exportedAsCopy});

  @override
  final String docId;
  @override
  final String n1Path;
  @override
  final String localPath;
  @override
  final bool exportedAsCopy;

  @override
  String toString() {
    return 'ExportEvent.docExported(docId: $docId, n1Path: $n1Path, localPath: $localPath, exportedAsCopy: $exportedAsCopy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocExported &&
            const DeepCollectionEquality().equals(other.docId, docId) &&
            const DeepCollectionEquality().equals(other.n1Path, n1Path) &&
            const DeepCollectionEquality().equals(other.localPath, localPath) &&
            const DeepCollectionEquality()
                .equals(other.exportedAsCopy, exportedAsCopy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(docId),
      const DeepCollectionEquality().hash(n1Path),
      const DeepCollectionEquality().hash(localPath),
      const DeepCollectionEquality().hash(exportedAsCopy));

  @JsonKey(ignore: true)
  @override
  _$$DocExportedCopyWith<_$DocExported> get copyWith =>
      __$$DocExportedCopyWithImpl<_$DocExported>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)
        beginExport,
    required TResult Function(String docId, String n1Path) docExportAttempt,
    required TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)
        docExported,
    required TResult Function(String docId, String n1Path, String localPath)
        docSkippedAlreadyExists,
    required TResult Function(String docId, String n1Path)
        docSkippedUnknownFailure,
    required TResult Function(
            Either<List<ExportFailure>, ExportResults> results)
        exportFinished,
  }) {
    return docExported(docId, n1Path, localPath, exportedAsCopy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
  }) {
    return docExported?.call(docId, n1Path, localPath, exportedAsCopy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
    required TResult orElse(),
  }) {
    if (docExported != null) {
      return docExported(docId, n1Path, localPath, exportedAsCopy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeginExport value) beginExport,
    required TResult Function(DocExportAttempt value) docExportAttempt,
    required TResult Function(DocExported value) docExported,
    required TResult Function(DocSkippedAlreadyExists value)
        docSkippedAlreadyExists,
    required TResult Function(DocSkippedUnknownFailure value)
        docSkippedUnknownFailure,
    required TResult Function(ExportFinished value) exportFinished,
  }) {
    return docExported(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
  }) {
    return docExported?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
    required TResult orElse(),
  }) {
    if (docExported != null) {
      return docExported(this);
    }
    return orElse();
  }
}

abstract class DocExported implements ExportEvent {
  const factory DocExported(
      {required final String docId,
      required final String n1Path,
      required final String localPath,
      required final bool exportedAsCopy}) = _$DocExported;

  String get docId;
  String get n1Path;
  String get localPath;
  bool get exportedAsCopy;
  @JsonKey(ignore: true)
  _$$DocExportedCopyWith<_$DocExported> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocSkippedAlreadyExistsCopyWith<$Res> {
  factory _$$DocSkippedAlreadyExistsCopyWith(_$DocSkippedAlreadyExists value,
          $Res Function(_$DocSkippedAlreadyExists) then) =
      __$$DocSkippedAlreadyExistsCopyWithImpl<$Res>;
  $Res call({String docId, String n1Path, String localPath});
}

/// @nodoc
class __$$DocSkippedAlreadyExistsCopyWithImpl<$Res>
    extends _$ExportEventCopyWithImpl<$Res>
    implements _$$DocSkippedAlreadyExistsCopyWith<$Res> {
  __$$DocSkippedAlreadyExistsCopyWithImpl(_$DocSkippedAlreadyExists _value,
      $Res Function(_$DocSkippedAlreadyExists) _then)
      : super(_value, (v) => _then(v as _$DocSkippedAlreadyExists));

  @override
  _$DocSkippedAlreadyExists get _value =>
      super._value as _$DocSkippedAlreadyExists;

  @override
  $Res call({
    Object? docId = freezed,
    Object? n1Path = freezed,
    Object? localPath = freezed,
  }) {
    return _then(_$DocSkippedAlreadyExists(
      docId: docId == freezed
          ? _value.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String,
      n1Path: n1Path == freezed
          ? _value.n1Path
          : n1Path // ignore: cast_nullable_to_non_nullable
              as String,
      localPath: localPath == freezed
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DocSkippedAlreadyExists implements DocSkippedAlreadyExists {
  const _$DocSkippedAlreadyExists(
      {required this.docId, required this.n1Path, required this.localPath});

  @override
  final String docId;
  @override
  final String n1Path;
  @override
  final String localPath;

  @override
  String toString() {
    return 'ExportEvent.docSkippedAlreadyExists(docId: $docId, n1Path: $n1Path, localPath: $localPath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocSkippedAlreadyExists &&
            const DeepCollectionEquality().equals(other.docId, docId) &&
            const DeepCollectionEquality().equals(other.n1Path, n1Path) &&
            const DeepCollectionEquality().equals(other.localPath, localPath));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(docId),
      const DeepCollectionEquality().hash(n1Path),
      const DeepCollectionEquality().hash(localPath));

  @JsonKey(ignore: true)
  @override
  _$$DocSkippedAlreadyExistsCopyWith<_$DocSkippedAlreadyExists> get copyWith =>
      __$$DocSkippedAlreadyExistsCopyWithImpl<_$DocSkippedAlreadyExists>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)
        beginExport,
    required TResult Function(String docId, String n1Path) docExportAttempt,
    required TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)
        docExported,
    required TResult Function(String docId, String n1Path, String localPath)
        docSkippedAlreadyExists,
    required TResult Function(String docId, String n1Path)
        docSkippedUnknownFailure,
    required TResult Function(
            Either<List<ExportFailure>, ExportResults> results)
        exportFinished,
  }) {
    return docSkippedAlreadyExists(docId, n1Path, localPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
  }) {
    return docSkippedAlreadyExists?.call(docId, n1Path, localPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
    required TResult orElse(),
  }) {
    if (docSkippedAlreadyExists != null) {
      return docSkippedAlreadyExists(docId, n1Path, localPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeginExport value) beginExport,
    required TResult Function(DocExportAttempt value) docExportAttempt,
    required TResult Function(DocExported value) docExported,
    required TResult Function(DocSkippedAlreadyExists value)
        docSkippedAlreadyExists,
    required TResult Function(DocSkippedUnknownFailure value)
        docSkippedUnknownFailure,
    required TResult Function(ExportFinished value) exportFinished,
  }) {
    return docSkippedAlreadyExists(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
  }) {
    return docSkippedAlreadyExists?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
    required TResult orElse(),
  }) {
    if (docSkippedAlreadyExists != null) {
      return docSkippedAlreadyExists(this);
    }
    return orElse();
  }
}

abstract class DocSkippedAlreadyExists implements ExportEvent {
  const factory DocSkippedAlreadyExists(
      {required final String docId,
      required final String n1Path,
      required final String localPath}) = _$DocSkippedAlreadyExists;

  String get docId;
  String get n1Path;
  String get localPath;
  @JsonKey(ignore: true)
  _$$DocSkippedAlreadyExistsCopyWith<_$DocSkippedAlreadyExists> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocSkippedUnknownFailureCopyWith<$Res> {
  factory _$$DocSkippedUnknownFailureCopyWith(_$DocSkippedUnknownFailure value,
          $Res Function(_$DocSkippedUnknownFailure) then) =
      __$$DocSkippedUnknownFailureCopyWithImpl<$Res>;
  $Res call({String docId, String n1Path});
}

/// @nodoc
class __$$DocSkippedUnknownFailureCopyWithImpl<$Res>
    extends _$ExportEventCopyWithImpl<$Res>
    implements _$$DocSkippedUnknownFailureCopyWith<$Res> {
  __$$DocSkippedUnknownFailureCopyWithImpl(_$DocSkippedUnknownFailure _value,
      $Res Function(_$DocSkippedUnknownFailure) _then)
      : super(_value, (v) => _then(v as _$DocSkippedUnknownFailure));

  @override
  _$DocSkippedUnknownFailure get _value =>
      super._value as _$DocSkippedUnknownFailure;

  @override
  $Res call({
    Object? docId = freezed,
    Object? n1Path = freezed,
  }) {
    return _then(_$DocSkippedUnknownFailure(
      docId: docId == freezed
          ? _value.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String,
      n1Path: n1Path == freezed
          ? _value.n1Path
          : n1Path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DocSkippedUnknownFailure implements DocSkippedUnknownFailure {
  const _$DocSkippedUnknownFailure({required this.docId, required this.n1Path});

  @override
  final String docId;
  @override
  final String n1Path;

  @override
  String toString() {
    return 'ExportEvent.docSkippedUnknownFailure(docId: $docId, n1Path: $n1Path)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocSkippedUnknownFailure &&
            const DeepCollectionEquality().equals(other.docId, docId) &&
            const DeepCollectionEquality().equals(other.n1Path, n1Path));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(docId),
      const DeepCollectionEquality().hash(n1Path));

  @JsonKey(ignore: true)
  @override
  _$$DocSkippedUnknownFailureCopyWith<_$DocSkippedUnknownFailure>
      get copyWith =>
          __$$DocSkippedUnknownFailureCopyWithImpl<_$DocSkippedUnknownFailure>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)
        beginExport,
    required TResult Function(String docId, String n1Path) docExportAttempt,
    required TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)
        docExported,
    required TResult Function(String docId, String n1Path, String localPath)
        docSkippedAlreadyExists,
    required TResult Function(String docId, String n1Path)
        docSkippedUnknownFailure,
    required TResult Function(
            Either<List<ExportFailure>, ExportResults> results)
        exportFinished,
  }) {
    return docSkippedUnknownFailure(docId, n1Path);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
  }) {
    return docSkippedUnknownFailure?.call(docId, n1Path);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
    required TResult orElse(),
  }) {
    if (docSkippedUnknownFailure != null) {
      return docSkippedUnknownFailure(docId, n1Path);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeginExport value) beginExport,
    required TResult Function(DocExportAttempt value) docExportAttempt,
    required TResult Function(DocExported value) docExported,
    required TResult Function(DocSkippedAlreadyExists value)
        docSkippedAlreadyExists,
    required TResult Function(DocSkippedUnknownFailure value)
        docSkippedUnknownFailure,
    required TResult Function(ExportFinished value) exportFinished,
  }) {
    return docSkippedUnknownFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
  }) {
    return docSkippedUnknownFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
    required TResult orElse(),
  }) {
    if (docSkippedUnknownFailure != null) {
      return docSkippedUnknownFailure(this);
    }
    return orElse();
  }
}

abstract class DocSkippedUnknownFailure implements ExportEvent {
  const factory DocSkippedUnknownFailure(
      {required final String docId,
      required final String n1Path}) = _$DocSkippedUnknownFailure;

  String get docId;
  String get n1Path;
  @JsonKey(ignore: true)
  _$$DocSkippedUnknownFailureCopyWith<_$DocSkippedUnknownFailure>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExportFinishedCopyWith<$Res> {
  factory _$$ExportFinishedCopyWith(
          _$ExportFinished value, $Res Function(_$ExportFinished) then) =
      __$$ExportFinishedCopyWithImpl<$Res>;
  $Res call({Either<List<ExportFailure>, ExportResults> results});
}

/// @nodoc
class __$$ExportFinishedCopyWithImpl<$Res>
    extends _$ExportEventCopyWithImpl<$Res>
    implements _$$ExportFinishedCopyWith<$Res> {
  __$$ExportFinishedCopyWithImpl(
      _$ExportFinished _value, $Res Function(_$ExportFinished) _then)
      : super(_value, (v) => _then(v as _$ExportFinished));

  @override
  _$ExportFinished get _value => super._value as _$ExportFinished;

  @override
  $Res call({
    Object? results = freezed,
  }) {
    return _then(_$ExportFinished(
      results: results == freezed
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as Either<List<ExportFailure>, ExportResults>,
    ));
  }
}

/// @nodoc

class _$ExportFinished implements ExportFinished {
  const _$ExportFinished({required this.results});

  @override
  final Either<List<ExportFailure>, ExportResults> results;

  @override
  String toString() {
    return 'ExportEvent.exportFinished(results: $results)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExportFinished &&
            const DeepCollectionEquality().equals(other.results, results));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(results));

  @JsonKey(ignore: true)
  @override
  _$$ExportFinishedCopyWith<_$ExportFinished> get copyWith =>
      __$$ExportFinishedCopyWithImpl<_$ExportFinished>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)
        beginExport,
    required TResult Function(String docId, String n1Path) docExportAttempt,
    required TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)
        docExported,
    required TResult Function(String docId, String n1Path, String localPath)
        docSkippedAlreadyExists,
    required TResult Function(String docId, String n1Path)
        docSkippedUnknownFailure,
    required TResult Function(
            Either<List<ExportFailure>, ExportResults> results)
        exportFinished,
  }) {
    return exportFinished(results);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
  }) {
    return exportFinished?.call(results);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String orgId, String orgName, String projectId,
            String projectName, String localPath, int docCount)?
        beginExport,
    TResult Function(String docId, String n1Path)? docExportAttempt,
    TResult Function(
            String docId, String n1Path, String localPath, bool exportedAsCopy)?
        docExported,
    TResult Function(String docId, String n1Path, String localPath)?
        docSkippedAlreadyExists,
    TResult Function(String docId, String n1Path)? docSkippedUnknownFailure,
    TResult Function(Either<List<ExportFailure>, ExportResults> results)?
        exportFinished,
    required TResult orElse(),
  }) {
    if (exportFinished != null) {
      return exportFinished(results);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeginExport value) beginExport,
    required TResult Function(DocExportAttempt value) docExportAttempt,
    required TResult Function(DocExported value) docExported,
    required TResult Function(DocSkippedAlreadyExists value)
        docSkippedAlreadyExists,
    required TResult Function(DocSkippedUnknownFailure value)
        docSkippedUnknownFailure,
    required TResult Function(ExportFinished value) exportFinished,
  }) {
    return exportFinished(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
  }) {
    return exportFinished?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeginExport value)? beginExport,
    TResult Function(DocExportAttempt value)? docExportAttempt,
    TResult Function(DocExported value)? docExported,
    TResult Function(DocSkippedAlreadyExists value)? docSkippedAlreadyExists,
    TResult Function(DocSkippedUnknownFailure value)? docSkippedUnknownFailure,
    TResult Function(ExportFinished value)? exportFinished,
    required TResult orElse(),
  }) {
    if (exportFinished != null) {
      return exportFinished(this);
    }
    return orElse();
  }
}

abstract class ExportFinished implements ExportEvent {
  const factory ExportFinished(
          {required final Either<List<ExportFailure>, ExportResults> results}) =
      _$ExportFinished;

  Either<List<ExportFailure>, ExportResults> get results;
  @JsonKey(ignore: true)
  _$$ExportFinishedCopyWith<_$ExportFinished> get copyWith =>
      throw _privateConstructorUsedError;
}
