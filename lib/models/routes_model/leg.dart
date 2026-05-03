class Leg {
  double? weight;
  String? summary;
  double? duration;
  double? distance;

  Leg({this.weight, this.summary, this.duration, this.distance});

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
    weight: (json['weight'] as num?)?.toDouble(),
    summary: json['summary'] as String?,
    duration: (json['duration'] as num?)?.toDouble(),
    distance: (json['distance'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'weight': weight,
    'summary': summary,
    'duration': duration,
    'distance': distance,
  };
}
