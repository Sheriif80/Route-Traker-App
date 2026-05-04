import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:route_tracker_app/services/location_service.dart';

class CustomGoogleMaps extends StatefulWidget {
  const CustomGoogleMaps({
    super.key,
    required this.getCurrentUserLocation,
    this.polylinePoints,
  });
  final void Function(LatLng)? getCurrentUserLocation;
  final List<LatLng>? polylinePoints;

  @override
  State<CustomGoogleMaps> createState() => _CustomGoogleMapsState();
}

class _CustomGoogleMapsState extends State<CustomGoogleMaps> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? googleMapController;
  late LocationService locationService;
  late LatLng currentUserLocation;

  String? _mapStyle;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

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
      final LatLng latLng = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      widget.getCurrentUserLocation!(latLng);
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

  void drawRoute() {
    if (widget.polylinePoints != null) {
      final Polyline polyline = Polyline(
        polylineId: const PolylineId('route'),
        points: widget.polylinePoints!,
        color: Colors.blue, // You can customize the color
        width: 5, // You can customize the width
        startCap: Cap.squareCap,
        endCap: Cap.roundCap,
      );

      setState(() {
        _polylines.add(polyline);
      });
      final LatLngBounds latLngBounds = calculateLatLngBounds(
        widget.polylinePoints!,
      );
      googleMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(latLngBounds, 60),
      );
    }
  }

  LatLngBounds calculateLatLngBounds(List<LatLng> points) {
    if (points.isEmpty) {
      throw ArgumentError('Polyline points cannot be null or empty');
    }
    final double minLat = points.map((e) => e.latitude).reduce(min);
    final double maxLat = points.map((e) => e.latitude).reduce(max);
    final double minLng = points.map((e) => e.longitude).reduce(min);
    final double maxLng = points.map((e) => e.longitude).reduce(max);
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: initialCameraPosition,
          style: _mapStyle,
          markers: _markers,
          polylines: _polylines,
          onMapCreated: (controller) async {
            googleMapController = controller;
            getCurrentLocation();
          },
        ),
        Positioned(
          bottom: 20,
          right: 70,
          left: 70,
          child: ElevatedButton(
            onPressed: drawRoute,
            child: const Text('Draw Route'),
          ),
        ),
      ],
    );
  }
}
