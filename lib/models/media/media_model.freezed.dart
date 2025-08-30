// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MediaModel _$MediaModelFromJson(Map<String, dynamic> json) {
  return _MediaModel.fromJson(json);
}

/// @nodoc
mixin _$MediaModel {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_url')
  String get mediaUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_format')
  String get mediaFormat => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_size')
  double get mediaSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_width')
  int get mediaWidth => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_height')
  int get mediaHeight => throw _privateConstructorUsedError;

  /// Serializes this MediaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaModelCopyWith<MediaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaModelCopyWith<$Res> {
  factory $MediaModelCopyWith(
          MediaModel value, $Res Function(MediaModel) then) =
      _$MediaModelCopyWithImpl<$Res, MediaModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'media_url') String mediaUrl,
      @JsonKey(name: 'media_format') String mediaFormat,
      @JsonKey(name: 'media_size') double mediaSize,
      @JsonKey(name: 'media_width') int mediaWidth,
      @JsonKey(name: 'media_height') int mediaHeight});
}

/// @nodoc
class _$MediaModelCopyWithImpl<$Res, $Val extends MediaModel>
    implements $MediaModelCopyWith<$Res> {
  _$MediaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mediaUrl = null,
    Object? mediaFormat = null,
    Object? mediaSize = null,
    Object? mediaWidth = null,
    Object? mediaHeight = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      mediaUrl: null == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
      mediaFormat: null == mediaFormat
          ? _value.mediaFormat
          : mediaFormat // ignore: cast_nullable_to_non_nullable
              as String,
      mediaSize: null == mediaSize
          ? _value.mediaSize
          : mediaSize // ignore: cast_nullable_to_non_nullable
              as double,
      mediaWidth: null == mediaWidth
          ? _value.mediaWidth
          : mediaWidth // ignore: cast_nullable_to_non_nullable
              as int,
      mediaHeight: null == mediaHeight
          ? _value.mediaHeight
          : mediaHeight // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaModelImplCopyWith<$Res>
    implements $MediaModelCopyWith<$Res> {
  factory _$$MediaModelImplCopyWith(
          _$MediaModelImpl value, $Res Function(_$MediaModelImpl) then) =
      __$$MediaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'media_url') String mediaUrl,
      @JsonKey(name: 'media_format') String mediaFormat,
      @JsonKey(name: 'media_size') double mediaSize,
      @JsonKey(name: 'media_width') int mediaWidth,
      @JsonKey(name: 'media_height') int mediaHeight});
}

/// @nodoc
class __$$MediaModelImplCopyWithImpl<$Res>
    extends _$MediaModelCopyWithImpl<$Res, _$MediaModelImpl>
    implements _$$MediaModelImplCopyWith<$Res> {
  __$$MediaModelImplCopyWithImpl(
      _$MediaModelImpl _value, $Res Function(_$MediaModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mediaUrl = null,
    Object? mediaFormat = null,
    Object? mediaSize = null,
    Object? mediaWidth = null,
    Object? mediaHeight = null,
  }) {
    return _then(_$MediaModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      mediaUrl: null == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
      mediaFormat: null == mediaFormat
          ? _value.mediaFormat
          : mediaFormat // ignore: cast_nullable_to_non_nullable
              as String,
      mediaSize: null == mediaSize
          ? _value.mediaSize
          : mediaSize // ignore: cast_nullable_to_non_nullable
              as double,
      mediaWidth: null == mediaWidth
          ? _value.mediaWidth
          : mediaWidth // ignore: cast_nullable_to_non_nullable
              as int,
      mediaHeight: null == mediaHeight
          ? _value.mediaHeight
          : mediaHeight // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaModelImpl implements _MediaModel {
  const _$MediaModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'media_url') required this.mediaUrl,
      @JsonKey(name: 'media_format') required this.mediaFormat,
      @JsonKey(name: 'media_size') required this.mediaSize,
      @JsonKey(name: 'media_width') required this.mediaWidth,
      @JsonKey(name: 'media_height') required this.mediaHeight});

  factory _$MediaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'media_url')
  final String mediaUrl;
  @override
  @JsonKey(name: 'media_format')
  final String mediaFormat;
  @override
  @JsonKey(name: 'media_size')
  final double mediaSize;
  @override
  @JsonKey(name: 'media_width')
  final int mediaWidth;
  @override
  @JsonKey(name: 'media_height')
  final int mediaHeight;

  @override
  String toString() {
    return 'MediaModel(id: $id, mediaUrl: $mediaUrl, mediaFormat: $mediaFormat, mediaSize: $mediaSize, mediaWidth: $mediaWidth, mediaHeight: $mediaHeight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.mediaFormat, mediaFormat) ||
                other.mediaFormat == mediaFormat) &&
            (identical(other.mediaSize, mediaSize) ||
                other.mediaSize == mediaSize) &&
            (identical(other.mediaWidth, mediaWidth) ||
                other.mediaWidth == mediaWidth) &&
            (identical(other.mediaHeight, mediaHeight) ||
                other.mediaHeight == mediaHeight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, mediaUrl, mediaFormat,
      mediaSize, mediaWidth, mediaHeight);

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaModelImplCopyWith<_$MediaModelImpl> get copyWith =>
      __$$MediaModelImplCopyWithImpl<_$MediaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaModelImplToJson(
      this,
    );
  }
}

abstract class _MediaModel implements MediaModel {
  const factory _MediaModel(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'media_url') required final String mediaUrl,
          @JsonKey(name: 'media_format') required final String mediaFormat,
          @JsonKey(name: 'media_size') required final double mediaSize,
          @JsonKey(name: 'media_width') required final int mediaWidth,
          @JsonKey(name: 'media_height') required final int mediaHeight}) =
      _$MediaModelImpl;

  factory _MediaModel.fromJson(Map<String, dynamic> json) =
      _$MediaModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'media_url')
  String get mediaUrl;
  @override
  @JsonKey(name: 'media_format')
  String get mediaFormat;
  @override
  @JsonKey(name: 'media_size')
  double get mediaSize;
  @override
  @JsonKey(name: 'media_width')
  int get mediaWidth;
  @override
  @JsonKey(name: 'media_height')
  int get mediaHeight;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaModelImplCopyWith<_$MediaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
