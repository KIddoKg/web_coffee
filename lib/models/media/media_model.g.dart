// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaModelImpl _$$MediaModelImplFromJson(Map<String, dynamic> json) =>
    _$MediaModelImpl(
      id: (json['id'] as num).toInt(),
      mediaUrl: json['media_url'] as String,
      mediaFormat: json['media_format'] as String,
      mediaSize: (json['media_size'] as num).toDouble(),
      mediaWidth: (json['media_width'] as num).toInt(),
      mediaHeight: (json['media_height'] as num).toInt(),
    );

Map<String, dynamic> _$$MediaModelImplToJson(_$MediaModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_url': instance.mediaUrl,
      'media_format': instance.mediaFormat,
      'media_size': instance.mediaSize,
      'media_width': instance.mediaWidth,
      'media_height': instance.mediaHeight,
    };
