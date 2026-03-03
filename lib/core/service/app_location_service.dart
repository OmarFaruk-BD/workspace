import 'package:logger/logger.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

class AppLocationService {
  final Logger _logger = Logger();
  final loc.Location _location = loc.Location();

  Future<bool> serviceEnabled() async {
    final status = await _location.serviceEnabled();
    return status;
  }

  Future<bool> requestLocationService() async {
    final status = await _location.requestService();
    return status;
  }

  Future<AppLocationModel?> getMyLocation() async {
    try {
      LocationData? currentLocation = await _location.getLocation();
      List<Placemark> newPlace = await placemarkFromCoordinates(
        currentLocation.latitude ?? 0,
        currentLocation.longitude ?? 0,
      );
      if (newPlace.isNotEmpty) {
        Placemark placeMark = newPlace.first;
        final myLocationModel = AppLocationModel(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
          name: placeMark.name,
          street: placeMark.street,
          isoCountryCode: placeMark.isoCountryCode,
          country: placeMark.country,
          postalCode: placeMark.postalCode,
          administrativeArea: placeMark.administrativeArea,
          subAdministrativeArea: placeMark.subAdministrativeArea,
          locality: placeMark.locality,
          subLocality: placeMark.subLocality,
          thoroughfare: placeMark.thoroughfare,
          subThoroughfare: placeMark.subThoroughfare,
        );
        return myLocationModel;
      } else {
        _logger.e('Failed to get location');
        return null;
      }
    } catch (e) {
      _logger.e('Error occurred while getting location: $e');
      return null;
    }
  }

  Future<AppLocationModel?> getLocationDetail(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> newPlace = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (newPlace.isNotEmpty) {
        Placemark placeMark = newPlace.first;
        final myLocationModel = AppLocationModel(
          latitude: latitude,
          longitude: longitude,
          name: placeMark.name,
          street: placeMark.street,
          isoCountryCode: placeMark.isoCountryCode,
          country: placeMark.country,
          postalCode: placeMark.postalCode,
          administrativeArea: placeMark.administrativeArea,
          subAdministrativeArea: placeMark.subAdministrativeArea,
          locality: placeMark.locality,
          subLocality: placeMark.subLocality,
          thoroughfare: placeMark.thoroughfare,
          subThoroughfare: placeMark.subThoroughfare,
        );
        return myLocationModel;
      } else {
        _logger.e('Failed to get location');
        return null;
      }
    } catch (e) {
      _logger.e('Error occurred while getting location: $e');
      return null;
    }
  }
}

class AppLocationModel {
  AppLocationModel({
    this.latitude,
    this.longitude,
    this.name,
    this.street,
    this.isoCountryCode,
    this.country,
    this.postalCode,
    this.administrativeArea,
    this.subAdministrativeArea,
    this.locality,
    this.subLocality,
    this.thoroughfare,
    this.subThoroughfare,
  });
  double? latitude;
  double? longitude;
  String? name;
  String? street;
  String? isoCountryCode;
  String? country;
  String? postalCode;
  String? administrativeArea;
  String? subAdministrativeArea;
  String? locality;
  String? subLocality;
  String? thoroughfare;
  String? subThoroughfare;

  String get address {
    return [
      locality,
      administrativeArea,
      country,
    ].where((e) => e != null && e.isNotEmpty).join(', ');
  }
}
