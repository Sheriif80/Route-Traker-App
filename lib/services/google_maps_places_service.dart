import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:route_tracker_app/errors/failures.dart';
import 'package:route_tracker_app/models/place_auto_complete_model/place_auto_complete_model.dart';
import 'package:route_tracker_app/models/routes_model/routes_model.dart';

abstract class GoogleMapsPlacesService {
  // For sorry, I'll be working on LocationIQ service instead of Google Maps,
  // as I don't have access to Google Maps.
  // That's because of the billing methods needed to use Google Maps API key.
  Future<Either<Failures, List<PlaceAutoCompleteModel>>> getPlaceAutoComplete(
    String placeText,
  );
  Future<Either<Failures, RoutesModel>> getRoutes({
    required String startLongitude,
    required String startLatitude,
    required String endLongitude,
    required String endLatitude,
  });
}

class GoogleMapsPlacesServiceImpl implements GoogleMapsPlacesService {
  // For sorry, I'll be working on LocationIQ service instead of Google Maps,
  // as I don't have access to Google Maps.
  // That's because of the billing methods needed to use Google Maps API key.

  final String baseUrl = 'https://api.locationiq.com/';
  final String apiKey = dotenv.env['locationIQ_ApiKey']!;
  final Dio dio = Dio();
  @override
  Future<Either<Failures, List<PlaceAutoCompleteModel>>> getPlaceAutoComplete(
    String placeText,
  ) async {
    try {
      final String autoCompleteEndPoint = 'v1/autocomplete';

      final response = await dio.get(
        '$baseUrl$autoCompleteEndPoint',
        queryParameters: {'key': apiKey, 'q': placeText, 'limit': 10},
      );
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        final List<PlaceAutoCompleteModel> places = data
            .map((e) => PlaceAutoCompleteModel.fromJson(e))
            .toList();
        return right(places);
      } else {
        return left(ServerFailure('Something went wrong'));
      }
    } on DioException catch (e) {
      log(e.message ?? 'Something went wrong');
      return left(ServerFailure(e.message ?? 'Something went wrong'));
    } catch (e) {
      log(e.toString());
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, RoutesModel>> getRoutes({
    required String startLongitude,
    required String startLatitude,
    required String endLongitude,
    required String endLatitude,
  }) async {
    try {
      // Actually, I'm using directions API not routes API
      // bcs routes API not available in LocationIQ.

      final String routesEndPoint = 'v1/directions/driving/';
      final String start = "$startLongitude,$startLatitude";
      final String end = "$endLongitude,$endLatitude";
      final response = await dio.get(
        '$baseUrl$routesEndPoint$start;$end',
        queryParameters: {
          'key': apiKey,

          // 'alternatives': 'true',
          // 'steps': 'true',
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        final RoutesModel routes = RoutesModel.fromJson(response.data);
        return right(routes);
      } else {
        return left(ServerFailure('Something went wrong'));
      }
    } on DioException catch (e) {
      log(e.message ?? 'Something went wrong');
      return left(ServerFailure(e.message ?? 'Something went wrong'));
    } catch (e) {
      log(e.toString());
      return left(ServerFailure(e.toString()));
    }
  }
}
