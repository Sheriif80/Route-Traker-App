import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:route_tracker_app/errors/failures.dart';
import 'package:route_tracker_app/models/place_auto_complete_model/place_auto_complete_model.dart';

abstract class GoogleMapsPlacesService {
  Future<Either<Failures, List<PlaceAutoCompleteModel>>> getPlaceAutoComplete(
    String placeText,
  );
}

class GoogleMapsPlacesServiceImpl implements GoogleMapsPlacesService {
  final String apiKey = dotenv.env['locationIQ_ApiKey']!;
  @override
  Future<Either<Failures, List<PlaceAutoCompleteModel>>> getPlaceAutoComplete(
    String placeText,
  ) async {
    try {
      final Dio dio = Dio();
      final String baseUrl = 'https://api.locationiq.com/';
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
}
