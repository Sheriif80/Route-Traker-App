import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:route_tracker_app/services/location_service.dart';

class CustomGoogleMaps extends StatefulWidget {
  const CustomGoogleMaps({super.key});

  @override
  State<CustomGoogleMaps> createState() => _CustomGoogleMapsState();
}

class _CustomGoogleMapsState extends State<CustomGoogleMaps> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? googleMapController;
  late LocationService locationService;

  String? _mapStyle;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    initialCameraPosition = const CameraPosition(target: LatLng(0, 0), zoom: 3);

    locationService = LocationService();

    loadMapStyle();
  }

  Future<void> getCurrentLocation() async {
    try {
      final LocationData locationData = await locationService.getLocationData();
      final CameraPosition cameraPosition = CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 18,
      );
      final Marker marker = Marker(
        markerId: const MarkerId("1"),
        position: LatLng(locationData.latitude!, locationData.longitude!),
      );
      setState(() {
        _markers.add(marker);
      });
      googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
    } on LocationServiceException catch (e) {
      debugPrint(e.message);
    } on LocationPermissionException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<void> loadMapStyle() async {
    final String style = await rootBundle.loadString(
      'assets/map_styles/night_map_style.json',
    );
    setState(() {
      _mapStyle = style;
    });
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      style: _mapStyle,
      markers: _markers,
      onMapCreated: (controller) async {
        googleMapController = controller;
        getCurrentLocation();
      },
    );
  }
}
