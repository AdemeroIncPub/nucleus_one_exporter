// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'export_documents_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ExportDocumentsArgs {
  String get orgId => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get destination => throw _privateConstructorUsedError;
  bool get allowNonEmptyDestination => throw _privateConstructorUsedError;
  bool get copyIfExists => throw _privateConstructorUsedError;
  String get maxConcurrentDownloads => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExportDocumentsArgsCopyWith<ExportDocumentsArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExportDocumentsArgsCopyWith<$Res> {
  factory $ExportDocumentsArgsCopyWith(
          ExportDocumentsArgs value, $Res Function(ExportDocumentsArgs) then) =
      _$ExportDocumentsArgsCopyWithImpl<$Res>;
  $Res call(
      {String orgId,
      String projectId,
      String destination,
      bool allowNonEmptyDestination,
      bool copyIfExists,
      String maxConcurrentDownloads});
}

/// @nodoc
class _$ExportDocumentsArgsCopyWithImpl<$Res>
    implements $ExportDocumentsArgsCopyWith<$Res> {
  _$ExportDocumentsArgsCopyWithImpl(this._value, this._then);

  final ExportDocumentsArgs _value;
  // ignore: unused_field
  final $Res Function(ExportDocumentsArgs) _then;

  @override
  $Res call({
    Object? orgId = freezed,
    Object? projectId = freezed,
    Object? destination = freezed,
    Object? allowNonEmptyDestination = freezed,
    Object? copyIfExists = freezed,
    Object? maxConcurrentDownloads = freezed,
  }) {
    return _then(_value.copyWith(
      orgId: orgId == freezed
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: projectId == freezed
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      destination: destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      allowNonEmptyDestination: allowNonEmptyDestination == freezed
          ? _value.allowNonEmptyDestination
          : allowNonEmptyDestination // ignore: cast_nullable_to_non_nullable
              as bool,
      copyIfExists: copyIfExists == freezed
          ? _value.copyIfExists
          : copyIfExists // ignore: cast_nullable_to_non_nullable
              as bool,
      maxConcurrentDownloads: maxConcurrentDownloads == freezed
          ? _value.maxConcurrentDownloads
          : maxConcurrentDownloads // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_ExportDocumentsArgsCopyWith<$Res>
    implements $ExportDocumentsArgsCopyWith<$Res> {
  factory _$$_ExportDocumentsArgsCopyWith(_$_ExportDocumentsArgs value,
          $Res Function(_$_ExportDocumentsArgs) then) =
      __$$_ExportDocumentsArgsCopyWithImpl<$Res>;
  @override
  $Res call(
      {String orgId,
      String projectId,
      String destination,
      bool allowNonEmptyDestination,
      bool copyIfExists,
      String maxConcurrentDownloads});
}

/// @nodoc
class __$$_ExportDocumentsArgsCopyWithImpl<$Res>
    extends _$ExportDocumentsArgsCopyWithImpl<$Res>
    implements _$$_ExportDocumentsArgsCopyWith<$Res> {
  __$$_ExportDocumentsArgsCopyWithImpl(_$_ExportDocumentsArgs _value,
      $Res Function(_$_ExportDocumentsArgs) _then)
      : super(_value, (v) => _then(v as _$_ExportDocumentsArgs));

  @override
  _$_ExportDocumentsArgs get _value => super._value as _$_ExportDocumentsArgs;

  @override
  $Res call({
    Object? orgId = freezed,
    Object? projectId = freezed,
    Object? destination = freezed,
    Object? allowNonEmptyDestination = freezed,
    Object? copyIfExists = freezed,
    Object? maxConcurrentDownloads = freezed,
  }) {
    return _then(_$_ExportDocumentsArgs(
      orgId: orgId == freezed
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: projectId == freezed
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      destination: destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      allowNonEmptyDestination: allowNonEmptyDestination == freezed
          ? _value.allowNonEmptyDestination
          : allowNonEmptyDestination // ignore: cast_nullable_to_non_nullable
              as bool,
      copyIfExists: copyIfExists == freezed
          ? _value.copyIfExists
          : copyIfExists // ignore: cast_nullable_to_non_nullable
              as bool,
      maxConcurrentDownloads: maxConcurrentDownloads == freezed
          ? _value.maxConcurrentDownloads
          : maxConcurrentDownloads // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ExportDocumentsArgs extends _ExportDocumentsArgs {
  _$_ExportDocumentsArgs(
      {required this.orgId,
      required this.projectId,
      required this.destination,
      required this.allowNonEmptyDestination,
      required this.copyIfExists,
      required this.maxConcurrentDownloads})
      : super._();

  @override
  final String orgId;
  @override
  final String projectId;
  @override
  final String destination;
  @override
  final bool allowNonEmptyDestination;
  @override
  final bool copyIfExists;
  @override
  final String maxConcurrentDownloads;

  @override
  String toString() {
    return 'ExportDocumentsArgs(orgId: $orgId, projectId: $projectId, destination: $destination, allowNonEmptyDestination: $allowNonEmptyDestination, copyIfExists: $copyIfExists, maxConcurrentDownloads: $maxConcurrentDownloads)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ExportDocumentsArgs &&
            const DeepCollectionEquality().equals(other.orgId, orgId) &&
            const DeepCollectionEquality().equals(other.projectId, projectId) &&
            const DeepCollectionEquality()
                .equals(other.destination, destination) &&
            const DeepCollectionEquality().equals(
                other.allowNonEmptyDestination, allowNonEmptyDestination) &&
            const DeepCollectionEquality()
                .equals(other.copyIfExists, copyIfExists) &&
            const DeepCollectionEquality()
                .equals(other.maxConcurrentDownloads, maxConcurrentDownloads));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(orgId),
      const DeepCollectionEquality().hash(projectId),
      const DeepCollectionEquality().hash(destination),
      const DeepCollectionEquality().hash(allowNonEmptyDestination),
      const DeepCollectionEquality().hash(copyIfExists),
      const DeepCollectionEquality().hash(maxConcurrentDownloads));

  @JsonKey(ignore: true)
  @override
  _$$_ExportDocumentsArgsCopyWith<_$_ExportDocumentsArgs> get copyWith =>
      __$$_ExportDocumentsArgsCopyWithImpl<_$_ExportDocumentsArgs>(
          this, _$identity);
}

abstract class _ExportDocumentsArgs extends ExportDocumentsArgs {
  factory _ExportDocumentsArgs(
      {required final String orgId,
      required final String projectId,
      required final String destination,
      required final bool allowNonEmptyDestination,
      required final bool copyIfExists,
      required final String maxConcurrentDownloads}) = _$_ExportDocumentsArgs;
  _ExportDocumentsArgs._() : super._();

  @override
  String get orgId;
  @override
  String get projectId;
  @override
  String get destination;
  @override
  bool get allowNonEmptyDestination;
  @override
  bool get copyIfExists;
  @override
  String get maxConcurrentDownloads;
  @override
  @JsonKey(ignore: true)
  _$$_ExportDocumentsArgsCopyWith<_$_ExportDocumentsArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ValidatedExportDocumentsArgs {
  String get orgId => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  Directory get destination => throw _privateConstructorUsedError;
  bool get allowNonEmptyDestination => throw _privateConstructorUsedError;
  bool get copyIfExists => throw _privateConstructorUsedError;
  int get maxConcurrentDownloads => throw _privateConstructorUsedError;
  ExportDocumentsArgs get originalArgs => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ValidatedExportDocumentsArgsCopyWith<ValidatedExportDocumentsArgs>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidatedExportDocumentsArgsCopyWith<$Res> {
  factory $ValidatedExportDocumentsArgsCopyWith(
          ValidatedExportDocumentsArgs value,
          $Res Function(ValidatedExportDocumentsArgs) then) =
      _$ValidatedExportDocumentsArgsCopyWithImpl<$Res>;
  $Res call(
      {String orgId,
      String projectId,
      Directory destination,
      bool allowNonEmptyDestination,
      bool copyIfExists,
      int maxConcurrentDownloads,
      ExportDocumentsArgs originalArgs});

  $ExportDocumentsArgsCopyWith<$Res> get originalArgs;
}

/// @nodoc
class _$ValidatedExportDocumentsArgsCopyWithImpl<$Res>
    implements $ValidatedExportDocumentsArgsCopyWith<$Res> {
  _$ValidatedExportDocumentsArgsCopyWithImpl(this._value, this._then);

  final ValidatedExportDocumentsArgs _value;
  // ignore: unused_field
  final $Res Function(ValidatedExportDocumentsArgs) _then;

  @override
  $Res call({
    Object? orgId = freezed,
    Object? projectId = freezed,
    Object? destination = freezed,
    Object? allowNonEmptyDestination = freezed,
    Object? copyIfExists = freezed,
    Object? maxConcurrentDownloads = freezed,
    Object? originalArgs = freezed,
  }) {
    return _then(_value.copyWith(
      orgId: orgId == freezed
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: projectId == freezed
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      destination: destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as Directory,
      allowNonEmptyDestination: allowNonEmptyDestination == freezed
          ? _value.allowNonEmptyDestination
          : allowNonEmptyDestination // ignore: cast_nullable_to_non_nullable
              as bool,
      copyIfExists: copyIfExists == freezed
          ? _value.copyIfExists
          : copyIfExists // ignore: cast_nullable_to_non_nullable
              as bool,
      maxConcurrentDownloads: maxConcurrentDownloads == freezed
          ? _value.maxConcurrentDownloads
          : maxConcurrentDownloads // ignore: cast_nullable_to_non_nullable
              as int,
      originalArgs: originalArgs == freezed
          ? _value.originalArgs
          : originalArgs // ignore: cast_nullable_to_non_nullable
              as ExportDocumentsArgs,
    ));
  }

  @override
  $ExportDocumentsArgsCopyWith<$Res> get originalArgs {
    return $ExportDocumentsArgsCopyWith<$Res>(_value.originalArgs, (value) {
      return _then(_value.copyWith(originalArgs: value));
    });
  }
}

/// @nodoc
abstract class _$$_ValidatedExportDocumentsArgsCopyWith<$Res>
    implements $ValidatedExportDocumentsArgsCopyWith<$Res> {
  factory _$$_ValidatedExportDocumentsArgsCopyWith(
          _$_ValidatedExportDocumentsArgs value,
          $Res Function(_$_ValidatedExportDocumentsArgs) then) =
      __$$_ValidatedExportDocumentsArgsCopyWithImpl<$Res>;
  @override
  $Res call(
      {String orgId,
      String projectId,
      Directory destination,
      bool allowNonEmptyDestination,
      bool copyIfExists,
      int maxConcurrentDownloads,
      ExportDocumentsArgs originalArgs});

  @override
  $ExportDocumentsArgsCopyWith<$Res> get originalArgs;
}

/// @nodoc
class __$$_ValidatedExportDocumentsArgsCopyWithImpl<$Res>
    extends _$ValidatedExportDocumentsArgsCopyWithImpl<$Res>
    implements _$$_ValidatedExportDocumentsArgsCopyWith<$Res> {
  __$$_ValidatedExportDocumentsArgsCopyWithImpl(
      _$_ValidatedExportDocumentsArgs _value,
      $Res Function(_$_ValidatedExportDocumentsArgs) _then)
      : super(_value, (v) => _then(v as _$_ValidatedExportDocumentsArgs));

  @override
  _$_ValidatedExportDocumentsArgs get _value =>
      super._value as _$_ValidatedExportDocumentsArgs;

  @override
  $Res call({
    Object? orgId = freezed,
    Object? projectId = freezed,
    Object? destination = freezed,
    Object? allowNonEmptyDestination = freezed,
    Object? copyIfExists = freezed,
    Object? maxConcurrentDownloads = freezed,
    Object? originalArgs = freezed,
  }) {
    return _then(_$_ValidatedExportDocumentsArgs(
      orgId: orgId == freezed
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: projectId == freezed
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      destination: destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as Directory,
      allowNonEmptyDestination: allowNonEmptyDestination == freezed
          ? _value.allowNonEmptyDestination
          : allowNonEmptyDestination // ignore: cast_nullable_to_non_nullable
              as bool,
      copyIfExists: copyIfExists == freezed
          ? _value.copyIfExists
          : copyIfExists // ignore: cast_nullable_to_non_nullable
              as bool,
      maxConcurrentDownloads: maxConcurrentDownloads == freezed
          ? _value.maxConcurrentDownloads
          : maxConcurrentDownloads // ignore: cast_nullable_to_non_nullable
              as int,
      originalArgs: originalArgs == freezed
          ? _value.originalArgs
          : originalArgs // ignore: cast_nullable_to_non_nullable
              as ExportDocumentsArgs,
    ));
  }
}

/// @nodoc

class _$_ValidatedExportDocumentsArgs implements _ValidatedExportDocumentsArgs {
  _$_ValidatedExportDocumentsArgs(
      {required this.orgId,
      required this.projectId,
      required this.destination,
      required this.allowNonEmptyDestination,
      required this.copyIfExists,
      required this.maxConcurrentDownloads,
      required this.originalArgs});

  @override
  final String orgId;
  @override
  final String projectId;
  @override
  final Directory destination;
  @override
  final bool allowNonEmptyDestination;
  @override
  final bool copyIfExists;
  @override
  final int maxConcurrentDownloads;
  @override
  final ExportDocumentsArgs originalArgs;

  @override
  String toString() {
    return 'ValidatedExportDocumentsArgs._internal(orgId: $orgId, projectId: $projectId, destination: $destination, allowNonEmptyDestination: $allowNonEmptyDestination, copyIfExists: $copyIfExists, maxConcurrentDownloads: $maxConcurrentDownloads, originalArgs: $originalArgs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ValidatedExportDocumentsArgs &&
            const DeepCollectionEquality().equals(other.orgId, orgId) &&
            const DeepCollectionEquality().equals(other.projectId, projectId) &&
            const DeepCollectionEquality()
                .equals(other.destination, destination) &&
            const DeepCollectionEquality().equals(
                other.allowNonEmptyDestination, allowNonEmptyDestination) &&
            const DeepCollectionEquality()
                .equals(other.copyIfExists, copyIfExists) &&
            const DeepCollectionEquality()
                .equals(other.maxConcurrentDownloads, maxConcurrentDownloads) &&
            const DeepCollectionEquality()
                .equals(other.originalArgs, originalArgs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(orgId),
      const DeepCollectionEquality().hash(projectId),
      const DeepCollectionEquality().hash(destination),
      const DeepCollectionEquality().hash(allowNonEmptyDestination),
      const DeepCollectionEquality().hash(copyIfExists),
      const DeepCollectionEquality().hash(maxConcurrentDownloads),
      const DeepCollectionEquality().hash(originalArgs));

  @JsonKey(ignore: true)
  @override
  _$$_ValidatedExportDocumentsArgsCopyWith<_$_ValidatedExportDocumentsArgs>
      get copyWith => __$$_ValidatedExportDocumentsArgsCopyWithImpl<
          _$_ValidatedExportDocumentsArgs>(this, _$identity);
}

abstract class _ValidatedExportDocumentsArgs
    implements ValidatedExportDocumentsArgs {
  factory _ValidatedExportDocumentsArgs(
          {required final String orgId,
          required final String projectId,
          required final Directory destination,
          required final bool allowNonEmptyDestination,
          required final bool copyIfExists,
          required final int maxConcurrentDownloads,
          required final ExportDocumentsArgs originalArgs}) =
      _$_ValidatedExportDocumentsArgs;

  @override
  String get orgId;
  @override
  String get projectId;
  @override
  Directory get destination;
  @override
  bool get allowNonEmptyDestination;
  @override
  bool get copyIfExists;
  @override
  int get maxConcurrentDownloads;
  @override
  ExportDocumentsArgs get originalArgs;
  @override
  @JsonKey(ignore: true)
  _$$_ValidatedExportDocumentsArgsCopyWith<_$_ValidatedExportDocumentsArgs>
      get copyWith => throw _privateConstructorUsedError;
}
