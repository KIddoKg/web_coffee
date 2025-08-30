// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentModelImpl _$$CommentModelImplFromJson(Map<String, dynamic> json) =>
    _$CommentModelImpl(
      initTime: json['init_time'] as String,
      objectId: json['object_id'] as String,
      objectUrl: json['object_url'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$$CommentModelImplToJson(_$CommentModelImpl instance) =>
    <String, dynamic>{
      'init_time': instance.initTime,
      'object_id': instance.objectId,
      'object_url': instance.objectUrl,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'comment': instance.comment,
    };
