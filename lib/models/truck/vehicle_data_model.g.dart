// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleDataModelImpl _$$VehicleDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VehicleDataModelImpl(
      name: json['name'] as String,
      gps: GPS.fromJson(json['gps'] as Map<String, dynamic>),
      sensor: Sensor.fromJson(json['sensor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VehicleDataModelImplToJson(
        _$VehicleDataModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'gps': instance.gps,
      'sensor': instance.sensor,
    };

_$GPSImpl _$$GPSImplFromJson(Map<String, dynamic> json) => _$GPSImpl(
      lat: json['lat'] as String,
      lng: json['lng'] as String,
      speed: json['speed'] as String,
    );

Map<String, dynamic> _$$GPSImplToJson(_$GPSImpl instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'speed': instance.speed,
    };

_$SensorImpl _$$SensorImplFromJson(Map<String, dynamic> json) => _$SensorImpl(
      fuel: json['fuel'] as String,
      weight: json['weight'] as String,
      flow: json['flow'] as String,
    );

Map<String, dynamic> _$$SensorImplToJson(_$SensorImpl instance) =>
    <String, dynamic>{
      'fuel': instance.fuel,
      'weight': instance.weight,
      'flow': instance.flow,
    };
