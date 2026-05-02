import 'address.dart';

class PlaceAutoCompleteModel {
  String? placeId;
  String? osmId;
  String? osmType;
  String? licence;
  String? lat;
  String? lon;
  List<String>? boundingbox;
  String? placeAutoCompleteModelClass;
  String? type;
  String? displayName;
  String? displayPlace;
  String? displayAddress;
  Address? address;

  PlaceAutoCompleteModel({
    this.placeId,
    this.osmId,
    this.osmType,
    this.licence,
    this.lat,
    this.lon,
    this.boundingbox,
    this.placeAutoCompleteModelClass,
    this.type,
    this.displayName,
    this.displayPlace,
    this.displayAddress,
    this.address,
  });

  factory PlaceAutoCompleteModel.fromJson(Map<String, dynamic> json) {
    return PlaceAutoCompleteModel(
      placeId: json['place_id'] as String?,
      osmId: json['osm_id'] as String?,
      osmType: json['osm_type'] as String?,
      licence: json['licence'] as String?,
      lat: json['lat'] as String?,
      lon: json['lon'] as String?,
      boundingbox: (json['boundingbox'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      placeAutoCompleteModelClass: json['class'] as String?,
      type: json['type'] as String?,
      displayName: json['display_name'] as String?,
      displayPlace: json['display_place'] as String?,
      displayAddress: json['display_address'] as String?,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'place_id': placeId,
    'osm_id': osmId,
    'osm_type': osmType,
    'licence': licence,
    'lat': lat,
    'lon': lon,
    'boundingbox': boundingbox,
    'class': placeAutoCompleteModelClass,
    'type': type,
    'display_name': displayName,
    'display_place': displayPlace,
    'display_address': displayAddress,
    'address': address?.toJson(),
  };
}
