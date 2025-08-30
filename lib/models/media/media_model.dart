import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_model.freezed.dart';
part 'media_model.g.dart';

@freezed
class MediaModel with _$MediaModel {
  const factory MediaModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'media_url') required String mediaUrl,
    @JsonKey(name: 'media_format') required String mediaFormat,
    @JsonKey(name: 'media_size') required double mediaSize,
    @JsonKey(name: 'media_width') required int mediaWidth,
    @JsonKey(name: 'media_height') required int mediaHeight,
  }) = _MediaModel;

  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);
}
