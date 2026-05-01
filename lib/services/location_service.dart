import 'dart:async';

import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationService {
  final Location location = Location();
  // This method's value that is returned can be a bool value to be
  // handled in the UI and return widget based on the value
  // but for now , just throw exception if location service is disabled
  Future<void> checkIfLocationServiceIsEnabled() async {
    try {
      bool isServiceEnabled = await location.serviceEnabled();
      if (!isServiceEnabled) {
        isServiceEnabled = await location.requestService();
        if (!isServiceEnabled) {
          throw LocationServiceException(
            "Location service is disabled, please enable it",
          );
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'SERVICE_STATUS_ERROR') {
        // The service is not yet bound (common in release mode on fast startup). Wait and retry.
        await Future.delayed(const Duration(milliseconds: 500));
        await checkIfLocationServiceIsEnabled();
      } else {
        rethrow;
      }
    }
  }

  Future<void> checkAndRequestLocationPermission() async {
    PermissionStatus permissionStatus = await location
        .hasPermission(); // first check
    if (permissionStatus == PermissionStatus.deniedForever) {
      throw LocationPermissionException(
        "Location permission is denied forever, please enable it",
      );
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        throw LocationPermissionException(
          "Location permission is denied, please enable it",
        );
      }
    }
  }

  Future<StreamSubscription<LocationData>?> getRealTimeLocation(
    void Function(LocationData) onData,
  ) async {
    await checkIfLocationServiceIsEnabled();
    await checkAndRequestLocationPermission();
    location.changeSettings(distanceFilter: 2);
    return location.onLocationChanged.listen(onData);
  }

  Future<LocationData> getLocationData() async {
    await checkIfLocationServiceIsEnabled();
    await checkAndRequestLocationPermission();
    return await location.getLocation();
  }
}

class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);
}

class LocationPermissionException implements Exception {
  final String message;
  LocationPermissionException(this.message);
}
