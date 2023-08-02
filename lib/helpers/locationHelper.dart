import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';

class LocationHelper {

  static Future<String> getAddress(Position pos) async {
    String address = "DefaultAdress";
    // final pos=Provider.of<LivePostionOfDevice>(context,listen: false).get_currentPostion();
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        address =
            "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      print("Error: $e");

      address = "Error fetching address";
    }

    return address;
  }
}
