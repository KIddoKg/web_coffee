// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserCommentModelImpl _$$UserCommentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserCommentModelImpl(
      initTime: json['init_time'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$$UserCommentModelImplToJson(
        _$UserCommentModelImpl instance) =>
    <String, dynamic>{
      'init_time': instance.initTime,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'comment': instance.comment,
    };
