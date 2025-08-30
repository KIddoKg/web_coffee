import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_file_model.freezed.dart';
part 'media_file_model.g.dart';

@freezed
class MediaFileModel with _$MediaFileModel {
  const factory MediaFileModel({
    required String id,
    @JsonKey(name: 'creator_id') required String creatorId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required String name,
    @JsonKey(name: 'custom_name') String? customName,
    @JsonKey(name: 'object_type') required String objectType,
    @JsonKey(name: 'file_type') required String fileType,
    required String url,
    required int size,
  }) = _MediaFileModel;

  factory MediaFileModel.fromJson(Map<String, dynamic> json) => _$MediaFileModelFromJson(json);
}
