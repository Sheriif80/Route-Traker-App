import 'leg.dart';

class Route {
  List<Leg>? legs;
  String? weightName;
  String? geometry;
  double? weight;
  double? duration;
  double? distance;

  Route({
    this.legs,
    this.weightName,
    this.geometry,
    this.weight,
    this.duration,
    this.distance,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    legs: (json['legs'] as List<dynamic>?)
        ?.map((e) => Leg.fromJson(e as Map<String, dynamic>))
        .toList(),
    weightName: json['weight_name'] as String?,
    geometry: json['geometry'] as String?,
    weight: (json['weight'] as num?)?.toDouble(),
    duration: (json['duration'] as num?)?.toDouble(),
    distance: (json['distance'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'legs': legs?.map((e) => e.toJson()).toList(),
    'weight_name': weightName,
    'geometry': geometry,
    'weight': weight,
    'duration': duration,
    'distance': distance,
  };
}
