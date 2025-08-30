// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaFileModelImpl _$$MediaFileModelImplFromJson(Map<String, dynamic> json) =>
    _$MediaFileModelImpl(
      id: json['id'] as String,
      creatorId: json['creator_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      name: json['name'] as String,
      customName: json['custom_name'] as String?,
      objectType: json['object_type'] as String,
      fileType: json['file_type'] as String,
      url: json['url'] as String,
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$$MediaFileModelImplToJson(
        _$MediaFileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creator_id': instance.creatorId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'name': instance.name,
      'custom_name': instance.customName,
      'object_type': instance.objectType,
      'file_type': instance.fileType,
      'url': instance.url,
      'size': instance.size,
    };
