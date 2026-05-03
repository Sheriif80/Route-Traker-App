import 'package:flutter/material.dart';
import 'package:route_tracker_app/models/place_auto_complete_model/place_auto_complete_model.dart';
import 'package:route_tracker_app/widgets/place_item.dart';

class PlacesListView extends StatelessWidget {
  const PlacesListView({
    super.key,
    required this.places,
    required this.onPlaceSelected,
  });
  final List<PlaceAutoCompleteModel> places;
  final void Function(PlaceAutoCompleteModel) onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: places.length,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        return PlaceItem(
          place: places[index],
          onPlaceSelected: onPlaceSelected,
        );
      },
    );
  }
}
