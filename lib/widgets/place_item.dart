import 'package:flutter/material.dart';
import 'package:route_tracker_app/models/place_auto_complete_model/place_auto_complete_model.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({
    super.key,
    required this.place,
    required this.onPlaceSelected,
  });
  final PlaceAutoCompleteModel place;
  final void Function(PlaceAutoCompleteModel) onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(26)),
      ),

      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.black),
        title: Text(
          place.displayName.toString(),
          style: const TextStyle(color: Colors.black),
        ),
        onTap: () {
          onPlaceSelected(place);
        },
      ),
    );
  }
}
