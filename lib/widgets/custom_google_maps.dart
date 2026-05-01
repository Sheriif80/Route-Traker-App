import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMaps extends StatefulWidget {
  const CustomGoogleMaps({super.key});

  @override
  State<CustomGoogleMaps> createState() => _CustomGoogleMapsState();
}

class _CustomGoogleMapsState extends State<CustomGoogleMaps> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? googleMapController;

  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    initialCameraPosition = const CameraPosition(
      target: LatLng(27.940325075705758, 30.82264086735967),
      zoom: 12,
    );
    loadMapStyle();
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
      onMapCreated: (controller) async {
        googleMapController = controller;
      },
    );
  }
}
