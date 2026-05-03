import 'package:flutter/material.dart';
import 'package:route_tracker_app/models/place_auto_complete_model/place_auto_complete_model.dart';
import 'package:route_tracker_app/services/google_maps_places_service.dart';
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

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    googleMapsPlacesService = GoogleMapsPlacesServiceImpl();
    fetchAutoCompletePlaces();
  }

  void fetchAutoCompletePlaces() async {
    _textController.addListener(() async {
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
        Positioned(
          top: 80,
          left: 20,
          right: 20,
          child: places.isNotEmpty
              ? PlacesListView(
                  places: places,
                  onPlaceSelected: (place) {
                    setState(() {
                      places.clear();
                      _textController.clear();
                    });
                    debugPrint(place.lat);
                    debugPrint(place.lon);
                  },
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
