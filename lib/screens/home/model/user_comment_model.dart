import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_comment_model.freezed.dart';
part 'user_comment_model.g.dart';

@freezed
class UserCommentModel with _$UserCommentModel {
  const factory UserCommentModel({
    @JsonKey(name: 'init_time') required String initTime,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_name') required String userName,
    required String comment,
  }) = _UserCommentModel;

  factory UserCommentModel.fromJson(Map<String, dynamic> json) =>
      _$UserCommentModelFromJson(json);
}
