// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VehicleDataModel _$VehicleDataModelFromJson(Map<String, dynamic> json) {
  return _VehicleDataModel.fromJson(json);
}

/// @nodoc
mixin _$VehicleDataModel {
  String get name => throw _privateConstructorUsedError;
  GPS get gps => throw _privateConstructorUsedError;
  Sensor get sensor => throw _privateConstructorUsedError;

  /// Serializes this VehicleDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleDataModelCopyWith<VehicleDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleDataModelCopyWith<$Res> {
  factory $VehicleDataModelCopyWith(
          VehicleDataModel value, $Res Function(VehicleDataModel) then) =
      _$VehicleDataModelCopyWithImpl<$Res, VehicleDataModel>;
  @useResult
  $Res call({String name, GPS gps, Sensor sensor});

  $GPSCopyWith<$Res> get gps;
  $SensorCopyWith<$Res> get sensor;
}

/// @nodoc
class _$VehicleDataModelCopyWithImpl<$Res, $Val extends VehicleDataModel>
    implements $VehicleDataModelCopyWith<$Res> {
  _$VehicleDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? gps = null,
    Object? sensor = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gps: null == gps
          ? _value.gps
          : gps // ignore: cast_nullable_to_non_nullable
              as GPS,
      sensor: null == sensor
          ? _value.sensor
          : sensor // ignore: cast_nullable_to_non_nullable
              as Sensor,
    ) as $Val);
  }

  /// Create a copy of VehicleDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GPSCopyWith<$Res> get gps {
    return $GPSCopyWith<$Res>(_value.gps, (value) {
      return _then(_value.copyWith(gps: value) as $Val);
    });
  }

  /// Create a copy of VehicleDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SensorCopyWith<$Res> get sensor {
    return $SensorCopyWith<$Res>(_value.sensor, (value) {
      return _then(_value.copyWith(sensor: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VehicleDataModelImplCopyWith<$Res>
    implements $VehicleDataModelCopyWith<$Res> {
  factory _$$VehicleDataModelImplCopyWith(_$VehicleDataModelImpl value,
          $Res Function(_$VehicleDataModelImpl) then) =
      __$$VehicleDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, GPS gps, Sensor sensor});

  @override
  $GPSCopyWith<$Res> get gps;
  @override
  $SensorCopyWith<$Res> get sensor;
}

/// @nodoc
class __$$VehicleDataModelImplCopyWithImpl<$Res>
    extends _$VehicleDataModelCopyWithImpl<$Res, _$VehicleDataModelImpl>
    implements _$$VehicleDataModelImplCopyWith<$Res> {
  __$$VehicleDataModelImplCopyWithImpl(_$VehicleDataModelImpl _value,
      $Res Function(_$VehicleDataModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VehicleDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? gps = null,
    Object? sensor = null,
  }) {
    return _then(_$VehicleDataModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gps: null == gps
          ? _value.gps
          : gps // ignore: cast_nullable_to_non_nullable
              as GPS,
      sensor: null == sensor
          ? _value.sensor
          : sensor // ignore: cast_nullable_to_non_nullable
              as Sensor,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleDataModelImpl implements _VehicleDataModel {
  const _$VehicleDataModelImpl(
      {required this.name, required this.gps, required this.sensor});

  factory _$VehicleDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleDataModelImplFromJson(json);

  @override
  final String name;
  @override
  final GPS gps;
  @override
  final Sensor sensor;

  @override
  String toString() {
    return 'VehicleDataModel(name: $name, gps: $gps, sensor: $sensor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleDataModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.gps, gps) || other.gps == gps) &&
            (identical(other.sensor, sensor) || other.sensor == sensor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, gps, sensor);

  /// Create a copy of VehicleDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleDataModelImplCopyWith<_$VehicleDataModelImpl> get copyWith =>
      __$$VehicleDataModelImplCopyWithImpl<_$VehicleDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleDataModelImplToJson(
      this,
    );
  }
}

abstract class _VehicleDataModel implements VehicleDataModel {
  const factory _VehicleDataModel(
      {required final String name,
      required final GPS gps,
      required final Sensor sensor}) = _$VehicleDataModelImpl;

  factory _VehicleDataModel.fromJson(Map<String, dynamic> json) =
      _$VehicleDataModelImpl.fromJson;

  @override
  String get name;
  @override
  GPS get gps;
  @override
  Sensor get sensor;

  /// Create a copy of VehicleDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleDataModelImplCopyWith<_$VehicleDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GPS _$GPSFromJson(Map<String, dynamic> json) {
  return _GPS.fromJson(json);
}

/// @nodoc
mixin _$GPS {
  String get lat => throw _privateConstructorUsedError;
  String get lng => throw _privateConstructorUsedError;
  String get speed => throw _privateConstructorUsedError;

  /// Serializes this GPS to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GPS
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GPSCopyWith<GPS> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GPSCopyWith<$Res> {
  factory $GPSCopyWith(GPS value, $Res Function(GPS) then) =
      _$GPSCopyWithImpl<$Res, GPS>;
  @useResult
  $Res call({String lat, String lng, String speed});
}

/// @nodoc
class _$GPSCopyWithImpl<$Res, $Val extends GPS> implements $GPSCopyWith<$Res> {
  _$GPSCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GPS
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
    Object? speed = null,
  }) {
    return _then(_value.copyWith(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as String,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as String,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GPSImplCopyWith<$Res> implements $GPSCopyWith<$Res> {
  factory _$$GPSImplCopyWith(_$GPSImpl value, $Res Function(_$GPSImpl) then) =
      __$$GPSImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String lat, String lng, String speed});
}

/// @nodoc
class __$$GPSImplCopyWithImpl<$Res> extends _$GPSCopyWithImpl<$Res, _$GPSImpl>
    implements _$$GPSImplCopyWith<$Res> {
  __$$GPSImplCopyWithImpl(_$GPSImpl _value, $Res Function(_$GPSImpl) _then)
      : super(_value, _then);

  /// Create a copy of GPS
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
    Object? speed = null,
  }) {
    return _then(_$GPSImpl(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as String,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as String,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GPSImpl implements _GPS {
  const _$GPSImpl({required this.lat, required this.lng, required this.speed});

  factory _$GPSImpl.fromJson(Map<String, dynamic> json) =>
      _$$GPSImplFromJson(json);

  @override
  final String lat;
  @override
  final String lng;
  @override
  final String speed;

  @override
  String toString() {
    return 'GPS(lat: $lat, lng: $lng, speed: $speed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GPSImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.speed, speed) || other.speed == speed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lng, speed);

  /// Create a copy of GPS
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GPSImplCopyWith<_$GPSImpl> get copyWith =>
      __$$GPSImplCopyWithImpl<_$GPSImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GPSImplToJson(
      this,
    );
  }
}

abstract class _GPS implements GPS {
  const factory _GPS(
      {required final String lat,
      required final String lng,
      required final String speed}) = _$GPSImpl;

  factory _GPS.fromJson(Map<String, dynamic> json) = _$GPSImpl.fromJson;

  @override
  String get lat;
  @override
  String get lng;
  @override
  String get speed;

  /// Create a copy of GPS
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GPSImplCopyWith<_$GPSImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Sensor _$SensorFromJson(Map<String, dynamic> json) {
  return _Sensor.fromJson(json);
}

/// @nodoc
mixin _$Sensor {
  String get fuel => throw _privateConstructorUsedError;
  String get weight => throw _privateConstructorUsedError;
  String get flow => throw _privateConstructorUsedError;

  /// Serializes this Sensor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Sensor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SensorCopyWith<Sensor> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SensorCopyWith<$Res> {
  factory $SensorCopyWith(Sensor value, $Res Function(Sensor) then) =
      _$SensorCopyWithImpl<$Res, Sensor>;
  @useResult
  $Res call({String fuel, String weight, String flow});
}

/// @nodoc
class _$SensorCopyWithImpl<$Res, $Val extends Sensor>
    implements $SensorCopyWith<$Res> {
  _$SensorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sensor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fuel = null,
    Object? weight = null,
    Object? flow = null,
  }) {
    return _then(_value.copyWith(
      fuel: null == fuel
          ? _value.fuel
          : fuel // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as String,
      flow: null == flow
          ? _value.flow
          : flow // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SensorImplCopyWith<$Res> implements $SensorCopyWith<$Res> {
  factory _$$SensorImplCopyWith(
          _$SensorImpl value, $Res Function(_$SensorImpl) then) =
      __$$SensorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fuel, String weight, String flow});
}

/// @nodoc
class __$$SensorImplCopyWithImpl<$Res>
    extends _$SensorCopyWithImpl<$Res, _$SensorImpl>
    implements _$$SensorImplCopyWith<$Res> {
  __$$SensorImplCopyWithImpl(
      _$SensorImpl _value, $Res Function(_$SensorImpl) _then)
      : super(_value, _then);

  /// Create a copy of Sensor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fuel = null,
    Object? weight = null,
    Object? flow = null,
  }) {
    return _then(_$SensorImpl(
      fuel: null == fuel
          ? _value.fuel
          : fuel // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as String,
      flow: null == flow
          ? _value.flow
          : flow // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SensorImpl implements _Sensor {
  const _$SensorImpl(
      {required this.fuel, required this.weight, required this.flow});

  factory _$SensorImpl.fromJson(Map<String, dynamic> json) =>
      _$$SensorImplFromJson(json);

  @override
  final String fuel;
  @override
  final String weight;
  @override
  final String flow;

  @override
  String toString() {
    return 'Sensor(fuel: $fuel, weight: $weight, flow: $flow)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SensorImpl &&
            (identical(other.fuel, fuel) || other.fuel == fuel) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.flow, flow) || other.flow == flow));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fuel, weight, flow);

  /// Create a copy of Sensor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SensorImplCopyWith<_$SensorImpl> get copyWith =>
      __$$SensorImplCopyWithImpl<_$SensorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SensorImplToJson(
      this,
    );
  }
}

abstract class _Sensor implements Sensor {
  const factory _Sensor(
      {required final String fuel,
      required final String weight,
      required final String flow}) = _$SensorImpl;

  factory _Sensor.fromJson(Map<String, dynamic> json) = _$SensorImpl.fromJson;

  @override
  String get fuel;
  @override
  String get weight;
  @override
  String get flow;

  /// Create a copy of Sensor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SensorImplCopyWith<_$SensorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
