// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserCommentModel _$UserCommentModelFromJson(Map<String, dynamic> json) {
  return _UserCommentModel.fromJson(json);
}

/// @nodoc
mixin _$UserCommentModel {
  @JsonKey(name: 'init_time')
  String get initTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String get userName => throw _privateConstructorUsedError;
  String get comment => throw _privateConstructorUsedError;

  /// Serializes this UserCommentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCommentModelCopyWith<UserCommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCommentModelCopyWith<$Res> {
  factory $UserCommentModelCopyWith(
          UserCommentModel value, $Res Function(UserCommentModel) then) =
      _$UserCommentModelCopyWithImpl<$Res, UserCommentModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'init_time') String initTime,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String userName,
      String comment});
}

/// @nodoc
class _$UserCommentModelCopyWithImpl<$Res, $Val extends UserCommentModel>
    implements $UserCommentModelCopyWith<$Res> {
  _$UserCommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initTime = null,
    Object? userId = null,
    Object? userName = null,
    Object? comment = null,
  }) {
    return _then(_value.copyWith(
      initTime: null == initTime
          ? _value.initTime
          : initTime // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserCommentModelImplCopyWith<$Res>
    implements $UserCommentModelCopyWith<$Res> {
  factory _$$UserCommentModelImplCopyWith(_$UserCommentModelImpl value,
          $Res Function(_$UserCommentModelImpl) then) =
      __$$UserCommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'init_time') String initTime,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String userName,
      String comment});
}

/// @nodoc
class __$$UserCommentModelImplCopyWithImpl<$Res>
    extends _$UserCommentModelCopyWithImpl<$Res, _$UserCommentModelImpl>
    implements _$$UserCommentModelImplCopyWith<$Res> {
  __$$UserCommentModelImplCopyWithImpl(_$UserCommentModelImpl _value,
      $Res Function(_$UserCommentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initTime = null,
    Object? userId = null,
    Object? userName = null,
    Object? comment = null,
  }) {
    return _then(_$UserCommentModelImpl(
      initTime: null == initTime
          ? _value.initTime
          : initTime // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserCommentModelImpl implements _UserCommentModel {
  const _$UserCommentModelImpl(
      {@JsonKey(name: 'init_time') required this.initTime,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'user_name') required this.userName,
      required this.comment});

  factory _$UserCommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserCommentModelImplFromJson(json);

  @override
  @JsonKey(name: 'init_time')
  final String initTime;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'user_name')
  final String userName;
  @override
  final String comment;

  @override
  String toString() {
    return 'UserCommentModel(initTime: $initTime, userId: $userId, userName: $userName, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserCommentModelImpl &&
            (identical(other.initTime, initTime) ||
                other.initTime == initTime) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, initTime, userId, userName, comment);

  /// Create a copy of UserCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserCommentModelImplCopyWith<_$UserCommentModelImpl> get copyWith =>
      __$$UserCommentModelImplCopyWithImpl<_$UserCommentModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserCommentModelImplToJson(
      this,
    );
  }
}

abstract class _UserCommentModel implements UserCommentModel {
  const factory _UserCommentModel(
      {@JsonKey(name: 'init_time') required final String initTime,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'user_name') required final String userName,
      required final String comment}) = _$UserCommentModelImpl;

  factory _UserCommentModel.fromJson(Map<String, dynamic> json) =
      _$UserCommentModelImpl.fromJson;

  @override
  @JsonKey(name: 'init_time')
  String get initTime;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'user_name')
  String get userName;
  @override
  String get comment;

  /// Create a copy of UserCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserCommentModelImplCopyWith<_$UserCommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
