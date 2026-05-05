import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker_app/models/place_auto_complete_model/place_auto_complete_model.dart';
import 'package:route_tracker_app/services/google_maps_places_service.dart';
import 'package:route_tracker_app/utils/debouncer.dart';
import 'package:route_tracker_app/widgets/custom_google_maps.dart';
import 'package:route_tracker_app/widgets/custom_text_field.dart';
import 'package:route_tracker_app/widgets/places_list_view.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  late TextEditingController _textController;
  late GoogleMapsPlacesService googleMapsPlacesService;

  List<PlaceAutoCompleteModel> places = [];
  late LatLng currentUserLocation;
  late LatLng destinationLocation;
  String? routeGeometry;

  final Debouncer debouncer = Debouncer(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    googleMapsPlacesService = GoogleMapsPlacesServiceImpl();
    fetchAutoCompletePlaces();
  }

  void fetchAutoCompletePlaces() {
    _textController.addListener(() {
      debouncer.run(() async {
        if (_textController.text.length >= 3) {
          final result = await googleMapsPlacesService.getPlaceAutoComplete(
            _textController.text,
          );
          result.fold(
            (failure) {
              debugPrint(failure.message);
            },
            (placesFetched) {
              setState(() {
                places = placesFetched;
              });
            },
          );
        } else {
          setState(() {
            places.clear();
          });
        }
      });
    });
  }

  Future<String> getRouteData() async {
    String? geometry;
    final result = await googleMapsPlacesService.getRoutes(
      startLongitude: currentUserLocation.longitude.toString(),
      startLatitude: currentUserLocation.latitude.toString(),
      endLongitude: destinationLocation.longitude.toString(),
      endLatitude: destinationLocation.latitude.toString(),
    );
    result.fold(
      (failure) {
        log(failure.message);
      },
      (routeData) {
        geometry = routeData.routes!.first.geometry;
      },
    );
    return geometry!;
  }

  List<LatLng> decodePolyline(String polyline) {
    final List<PointLatLng> result = PolylinePoints.decodePolyline(polyline);
    return result
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  @override
  void dispose() {
    _textController.dispose();
    debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomGoogleMaps(
          getCurrentUserLocation: (LatLng p1) {
            currentUserLocation = p1;
          },
          polylinePoints: routeGeometry != null
              ? decodePolyline(routeGeometry!)
              : [],
        ),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: CustomTextField(textController: _textController),
        ),
        Positioned(
          top: 80,
          left: 20,
          right: 20,
          child: places.isNotEmpty
              ? PlacesListView(
                  places: places,
                  onPlaceSelected: (place) async {
                    destinationLocation = LatLng(
                      double.parse(place.lat!),
                      double.parse(place.lon!),
                    );
                    log(destinationLocation.toString());
                    setState(() {
                      places.clear();
                      _textController.clear();
                    });
                    final String newGeometry = await getRouteData();

                    setState(() {
                      routeGeometry = newGeometry;
                    });
                  },
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
