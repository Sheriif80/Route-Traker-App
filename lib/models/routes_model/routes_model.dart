import 'route.dart';

class RoutesModel {
  String? code;
  List<Route>? routes;

  RoutesModel({this.code, this.routes});

  factory RoutesModel.fromJson(Map<String, dynamic> json) => RoutesModel(
    code: json['code'] as String?,
    routes: (json['routes'] as List<dynamic>?)
        ?.map((e) => Route.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'code': code,
    'routes': routes?.map((e) => e.toJson()).toList(),
  };
}
