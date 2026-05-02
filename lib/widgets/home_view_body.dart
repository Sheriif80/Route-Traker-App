import 'package:flutter/material.dart';
import 'package:route_tracker_app/services/google_maps_places_service.dart';
import 'package:route_tracker_app/widgets/custom_google_maps.dart';
import 'package:route_tracker_app/widgets/custom_text_field.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  late TextEditingController _textController;
  late GoogleMapsPlacesService googleMapsPlacesService;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    googleMapsPlacesService = GoogleMapsPlacesServiceImpl();
    fetchAutoCompletePlaces();
  }

  void fetchAutoCompletePlaces() {
    _textController.addListener(() {
      if (_textController.text.length >= 3) {
        googleMapsPlacesService.getPlaceAutoComplete(_textController.text);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomGoogleMaps(),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: CustomTextField(textController: _textController),
        ),
      ],
    );
  }
}
