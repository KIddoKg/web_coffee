// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      transactionId: (json['transaction_id'] as num).toInt(),
      priceRouter: (json['price_router'] as num).toDouble(),
      transactionStatus: json['transaction_status'] as String,
      transactionDateUnix: (json['transaction_date_unix'] as num).toInt(),
    );

Map<String, dynamic> _$$TransactionModelImplToJson(
        _$TransactionModelImpl instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionId,
      'price_router': instance.priceRouter,
      'transaction_status': instance.transactionStatus,
      'transaction_date_unix': instance.transactionDateUnix,
    };
