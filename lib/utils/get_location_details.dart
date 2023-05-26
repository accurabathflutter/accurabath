import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/globals.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

checkPermissionStatusFromUtils() async {
  bool is_LocationService_Permission;

  Location location;
  if (!await location.serviceEnabled()) {
    // location.requestService();

    if (Platform.isAndroid) {
      showCommonDialogWithSingleOption(Globals.context,
          "Can't get current location, Please make sure you enable GPS and try again !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        AppSettings.openLocationSettings(asAnotherTask: true);
        Navigator.pop(Globals.context);
      });
    }
  }
  bool granted = await Permission.location.isGranted;
  bool Denied = await Permission.location.isDenied;
  bool PermanentlyDenied = await Permission.location.isPermanentlyDenied;

  print("PermissionStatus" +
      "Granted : " +
      granted.toString() +
      " Denied : " +
      Denied.toString() +
      " PermanentlyDenied : " +
      PermanentlyDenied.toString());

  if (Denied == true) {
    // openAppSettings();
    is_LocationService_Permission = false;
    await Permission.storage.request();
    // await Permission.location.request();
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
  }
// You can can also directly ask the permission about its status.
  if (await Permission.location.isRestricted) {
    // The OS restricts access, for example because of parental controls.
    openAppSettings();
  }
  if (PermanentlyDenied == true) {
    // The user opted to never again see the permission request dialog for this
    // app. The only way to change the permission's status now is to let the
    // user manually enable it in the system settings.
    is_LocationService_Permission = false;
    openAppSettings();
  }

  if (granted == true) {
    // The OS restricts access, for example because of parental controls.
    is_LocationService_Permission = true;
  }

  return is_LocationService_Permission;
}

getCurrentLocationFromUtils() async {
  Geolocator geolocator123;
  String Longitude = "";
  String Latitude = "";
  String Address = "";
  Location location;

  geolocator123
      .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best)
      .then((Position position) async {
    Longitude = position.longitude.toString();
    Latitude = position.latitude.toString();

    /*if (MapAPIKey != "") {
        Address = await getAddressFromLatLng(Latitude, Longitude, MapAPIKey);
      } else {
        Address = "";
      }*/

    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        googleMapApiKey: "");

    Address = data
        .address; /*await getAddressFromLatLngMapMyIndia(
          Latitude, Longitude, MAPMYINDIAKEY);*/
    print("GogleAddress" + Address);
  }).catchError((e) {
    print(e);
  });

  location.onLocationChanged.listen((LocationData currentLocation) async {
    // Use current location
    print("OnLocationChange" +
        " Location : " +
        currentLocation.latitude.toString());
    Latitude = currentLocation.latitude.toString();
    Longitude = currentLocation.longitude.toString();
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
        googleMapApiKey: "");

    Address = data
        .address; /*await getAddressFromLatLngMapMyIndia(
          Latitude, Longitude, MAPMYINDIAKEY);*/
    print("GogleAddress" + Address);
  });

  ALL_Name_ID all_name_id = ALL_Name_ID();
  all_name_id.GoogleAddress = Address;
  all_name_id.Latitude = Latitude;
  all_name_id.Longitude = Longitude;

  return all_name_id;
}
