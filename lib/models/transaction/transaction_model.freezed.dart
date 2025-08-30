// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) {
  return _TransactionModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionModel {
  @JsonKey(name: 'transaction_id')
  int get transactionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_router')
  double get priceRouter => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_status')
  String get transactionStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_date_unix')
  int get transactionDateUnix => throw _privateConstructorUsedError;

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
          TransactionModel value, $Res Function(TransactionModel) then) =
      _$TransactionModelCopyWithImpl<$Res, TransactionModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'transaction_id') int transactionId,
      @JsonKey(name: 'price_router') double priceRouter,
      @JsonKey(name: 'transaction_status') String transactionStatus,
      @JsonKey(name: 'transaction_date_unix') int transactionDateUnix});
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res, $Val extends TransactionModel>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionId = null,
    Object? priceRouter = null,
    Object? transactionStatus = null,
    Object? transactionDateUnix = null,
  }) {
    return _then(_value.copyWith(
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as int,
      priceRouter: null == priceRouter
          ? _value.priceRouter
          : priceRouter // ignore: cast_nullable_to_non_nullable
              as double,
      transactionStatus: null == transactionStatus
          ? _value.transactionStatus
          : transactionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDateUnix: null == transactionDateUnix
          ? _value.transactionDateUnix
          : transactionDateUnix // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionModelImplCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$$TransactionModelImplCopyWith(_$TransactionModelImpl value,
          $Res Function(_$TransactionModelImpl) then) =
      __$$TransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'transaction_id') int transactionId,
      @JsonKey(name: 'price_router') double priceRouter,
      @JsonKey(name: 'transaction_status') String transactionStatus,
      @JsonKey(name: 'transaction_date_unix') int transactionDateUnix});
}

/// @nodoc
class __$$TransactionModelImplCopyWithImpl<$Res>
    extends _$TransactionModelCopyWithImpl<$Res, _$TransactionModelImpl>
    implements _$$TransactionModelImplCopyWith<$Res> {
  __$$TransactionModelImplCopyWithImpl(_$TransactionModelImpl _value,
      $Res Function(_$TransactionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionId = null,
    Object? priceRouter = null,
    Object? transactionStatus = null,
    Object? transactionDateUnix = null,
  }) {
    return _then(_$TransactionModelImpl(
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as int,
      priceRouter: null == priceRouter
          ? _value.priceRouter
          : priceRouter // ignore: cast_nullable_to_non_nullable
              as double,
      transactionStatus: null == transactionStatus
          ? _value.transactionStatus
          : transactionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDateUnix: null == transactionDateUnix
          ? _value.transactionDateUnix
          : transactionDateUnix // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionModelImpl implements _TransactionModel {
  const _$TransactionModelImpl(
      {@JsonKey(name: 'transaction_id') required this.transactionId,
      @JsonKey(name: 'price_router') required this.priceRouter,
      @JsonKey(name: 'transaction_status') required this.transactionStatus,
      @JsonKey(name: 'transaction_date_unix')
      required this.transactionDateUnix});

  factory _$TransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionModelImplFromJson(json);

  @override
  @JsonKey(name: 'transaction_id')
  final int transactionId;
  @override
  @JsonKey(name: 'price_router')
  final double priceRouter;
  @override
  @JsonKey(name: 'transaction_status')
  final String transactionStatus;
  @override
  @JsonKey(name: 'transaction_date_unix')
  final int transactionDateUnix;

  @override
  String toString() {
    return 'TransactionModel(transactionId: $transactionId, priceRouter: $priceRouter, transactionStatus: $transactionStatus, transactionDateUnix: $transactionDateUnix)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionModelImpl &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.priceRouter, priceRouter) ||
                other.priceRouter == priceRouter) &&
            (identical(other.transactionStatus, transactionStatus) ||
                other.transactionStatus == transactionStatus) &&
            (identical(other.transactionDateUnix, transactionDateUnix) ||
                other.transactionDateUnix == transactionDateUnix));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, transactionId, priceRouter,
      transactionStatus, transactionDateUnix);

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      __$$TransactionModelImplCopyWithImpl<_$TransactionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionModelImplToJson(
      this,
    );
  }
}

abstract class _TransactionModel implements TransactionModel {
  const factory _TransactionModel(
      {@JsonKey(name: 'transaction_id') required final int transactionId,
      @JsonKey(name: 'price_router') required final double priceRouter,
      @JsonKey(name: 'transaction_status')
      required final String transactionStatus,
      @JsonKey(name: 'transaction_date_unix')
      required final int transactionDateUnix}) = _$TransactionModelImpl;

  factory _TransactionModel.fromJson(Map<String, dynamic> json) =
      _$TransactionModelImpl.fromJson;

  @override
  @JsonKey(name: 'transaction_id')
  int get transactionId;
  @override
  @JsonKey(name: 'price_router')
  double get priceRouter;
  @override
  @JsonKey(name: 'transaction_status')
  String get transactionStatus;
  @override
  @JsonKey(name: 'transaction_date_unix')
  int get transactionDateUnix;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
