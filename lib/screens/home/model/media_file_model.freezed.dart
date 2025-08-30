// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_file_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MediaFileModel _$MediaFileModelFromJson(Map<String, dynamic> json) {
  return _MediaFileModel.fromJson(json);
}

/// @nodoc
mixin _$MediaFileModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'creator_id')
  String get creatorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'custom_name')
  String? get customName => throw _privateConstructorUsedError;
  @JsonKey(name: 'object_type')
  String get objectType => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_type')
  String get fileType => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;

  /// Serializes this MediaFileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MediaFileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaFileModelCopyWith<MediaFileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaFileModelCopyWith<$Res> {
  factory $MediaFileModelCopyWith(
          MediaFileModel value, $Res Function(MediaFileModel) then) =
      _$MediaFileModelCopyWithImpl<$Res, MediaFileModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'creator_id') String creatorId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      String name,
      @JsonKey(name: 'custom_name') String? customName,
      @JsonKey(name: 'object_type') String objectType,
      @JsonKey(name: 'file_type') String fileType,
      String url,
      int size});
}

/// @nodoc
class _$MediaFileModelCopyWithImpl<$Res, $Val extends MediaFileModel>
    implements $MediaFileModelCopyWith<$Res> {
  _$MediaFileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaFileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creatorId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? name = null,
    Object? customName = freezed,
    Object? objectType = null,
    Object? fileType = null,
    Object? url = null,
    Object? size = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      customName: freezed == customName
          ? _value.customName
          : customName // ignore: cast_nullable_to_non_nullable
              as String?,
      objectType: null == objectType
          ? _value.objectType
          : objectType // ignore: cast_nullable_to_non_nullable
              as String,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaFileModelImplCopyWith<$Res>
    implements $MediaFileModelCopyWith<$Res> {
  factory _$$MediaFileModelImplCopyWith(_$MediaFileModelImpl value,
          $Res Function(_$MediaFileModelImpl) then) =
      __$$MediaFileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'creator_id') String creatorId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      String name,
      @JsonKey(name: 'custom_name') String? customName,
      @JsonKey(name: 'object_type') String objectType,
      @JsonKey(name: 'file_type') String fileType,
      String url,
      int size});
}

/// @nodoc
class __$$MediaFileModelImplCopyWithImpl<$Res>
    extends _$MediaFileModelCopyWithImpl<$Res, _$MediaFileModelImpl>
    implements _$$MediaFileModelImplCopyWith<$Res> {
  __$$MediaFileModelImplCopyWithImpl(
      _$MediaFileModelImpl _value, $Res Function(_$MediaFileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaFileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creatorId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? name = null,
    Object? customName = freezed,
    Object? objectType = null,
    Object? fileType = null,
    Object? url = null,
    Object? size = null,
  }) {
    return _then(_$MediaFileModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      customName: freezed == customName
          ? _value.customName
          : customName // ignore: cast_nullable_to_non_nullable
              as String?,
      objectType: null == objectType
          ? _value.objectType
          : objectType // ignore: cast_nullable_to_non_nullable
              as String,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaFileModelImpl implements _MediaFileModel {
  const _$MediaFileModelImpl(
      {required this.id,
      @JsonKey(name: 'creator_id') required this.creatorId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      required this.name,
      @JsonKey(name: 'custom_name') this.customName,
      @JsonKey(name: 'object_type') required this.objectType,
      @JsonKey(name: 'file_type') required this.fileType,
      required this.url,
      required this.size});

  factory _$MediaFileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaFileModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'creator_id')
  final String creatorId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  final String name;
  @override
  @JsonKey(name: 'custom_name')
  final String? customName;
  @override
  @JsonKey(name: 'object_type')
  final String objectType;
  @override
  @JsonKey(name: 'file_type')
  final String fileType;
  @override
  final String url;
  @override
  final int size;

  @override
  String toString() {
    return 'MediaFileModel(id: $id, creatorId: $creatorId, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, customName: $customName, objectType: $objectType, fileType: $fileType, url: $url, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaFileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.customName, customName) ||
                other.customName == customName) &&
            (identical(other.objectType, objectType) ||
                other.objectType == objectType) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, creatorId, createdAt,
      updatedAt, name, customName, objectType, fileType, url, size);

  /// Create a copy of MediaFileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaFileModelImplCopyWith<_$MediaFileModelImpl> get copyWith =>
      __$$MediaFileModelImplCopyWithImpl<_$MediaFileModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaFileModelImplToJson(
      this,
    );
  }
}

abstract class _MediaFileModel implements MediaFileModel {
  const factory _MediaFileModel(
      {required final String id,
      @JsonKey(name: 'creator_id') required final String creatorId,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      required final String name,
      @JsonKey(name: 'custom_name') final String? customName,
      @JsonKey(name: 'object_type') required final String objectType,
      @JsonKey(name: 'file_type') required final String fileType,
      required final String url,
      required final int size}) = _$MediaFileModelImpl;

  factory _MediaFileModel.fromJson(Map<String, dynamic> json) =
      _$MediaFileModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'creator_id')
  String get creatorId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  String get name;
  @override
  @JsonKey(name: 'custom_name')
  String? get customName;
  @override
  @JsonKey(name: 'object_type')
  String get objectType;
  @override
  @JsonKey(name: 'file_type')
  String get fileType;
  @override
  String get url;
  @override
  int get size;

  /// Create a copy of MediaFileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaFileModelImplCopyWith<_$MediaFileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
