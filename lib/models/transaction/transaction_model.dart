import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    @JsonKey(name: 'transaction_id') required int transactionId,
    @JsonKey(name: 'price_router') required double priceRouter,
    @JsonKey(name: 'transaction_status') required String transactionStatus,
    @JsonKey(name: 'transaction_date_unix') required int transactionDateUnix,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
