import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  Future<bool> checkAndRequestLocationService() async {
    bool isServiceEnabled = await location.serviceEnabled();

    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        return false;
      }
    }

    return true;
  }

  Future<bool> checkAndRequestLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();

      return permissionStatus == PermissionStatus.granted ||
          permissionStatus == PermissionStatus.grantedLimited;
    }

    return true;
  }

  void getRealTimeLocation(Function(LocationData)? onData) async {
    location.onLocationChanged.listen(onData);
  }
}

// Zoom Levels:
// world view 0 - 3
// country view 4 - 6
// city view 10 - 12
// street view 13 - 17
// building view 18 - 20

/// Steps to get location:
/// 1- inquire about location service
/// 2- request permession
/// 3- get location
/// 4- display location
