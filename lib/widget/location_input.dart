import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:great_place/widget/printMap.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

//
import '../helpers/locationHelper.dart';
import '../screens/customLocationSelection_Screen.dart';
import '../provider/livePostion.dart';

//
class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   _getCurrentUserLocation();
  //   super.initState();
  // }

  // Future<void > _selectCustomLocation() async {
  //     final se
  // }
  String _previewImageUrl = "Default_Value";
  Position? _currentPostion;
  // LatLng _cordinates=LatLng(latitude, longitude);
  // Future<void> _getCurrentUserLocation() async {
  //   final locData = await Location().getLocation();
  //   print(locData.latitude);
  //   print(locData.longitude);

  //   setState(() {
  //     lat = locData.latitude as double;
  //     long = locData.longitude as double;
  //   });
  // }

  Future<void> _getCurrentUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        permission = await Geolocator.requestPermission();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    StreamSubscription<Position> positionStream =
        await Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? pos) {
      print(pos == null
          ? 'Unknown'
          : 'default print ${pos.latitude.toString()}, ${pos.longitude.toString()}');
      // setState(() {
      //   _currentPostion=pos;
      //   _cordinates = LatLng(_currentPostion!.latitude,_currentPostion!.longitude);

      // });
      Provider.of<LivePostionOfDevice>(context, listen: false)
          .update_Pos(pos as Position);
      print("returning current locaiton ${pos.latitude}");
    },);
  }

  Future<LatLng> loadLatLang() async {
    var livePos =
        await Provider.of<LivePostionOfDevice>(context).get_currentPostion();
    LatLng _cordinates = LatLng(
      livePos.latitude,
      livePos.longitude,
    );
    return _cordinates;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: FutureBuilder<LatLng>(
            future: loadLatLang(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while waiting for the future to complete.
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Show an error message if the future completes with an error.
                return Text('Error: ${snapshot.error}');
              } else {
                // Show the user data if the future completes successfully.
                return RenderMap(cordinates: snapshot.data as LatLng,preview_Window: true);
              }
            },
          ),
        ),
        // Text("Your Location is : latitude  $lat  longitude : $long "),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              heroTag: Text("Current Location"),
              icon: Icon(Icons.location_on),
              label: Text("Current Location"),
              onPressed: _getCurrentUserLocation,
            ),
            FloatingActionButton.extended(
              heroTag: Text("Select Location"),
              icon: Icon(Icons.map),
              label: Text("Select on Map"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => CustomLocSelection(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
