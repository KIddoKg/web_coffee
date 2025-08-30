import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_data_model.freezed.dart';
part 'vehicle_data_model.g.dart';

@freezed
class VehicleDataModel with _$VehicleDataModel {
  const factory VehicleDataModel({
    required String name,
    required GPS gps,
    required Sensor sensor,
  }) = _VehicleDataModel;

  factory VehicleDataModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleDataModelFromJson(json);
}

@freezed
class GPS with _$GPS {
  const factory GPS({
    required String lat,
    required String lng,
    required String speed,
  }) = _GPS;

  factory GPS.fromJson(Map<String, dynamic> json) => _$GPSFromJson(json);
}

@freezed
class Sensor with _$Sensor {
  const factory Sensor({
    required String fuel,
    required String weight,
    required String flow,
  }) = _Sensor;

  factory Sensor.fromJson(Map<String, dynamic> json) => _$SensorFromJson(json);
}
