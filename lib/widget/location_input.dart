import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
//
import '../helpers/locationHelper.dart';

//
class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl = "Default_Value";
  late double lat = 0.0;
  late double long = 0.0;
  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    print(locData.latitude);
    print(locData.longitude);

    setState(() {
        lat = locData.latitude as double;
    long = locData.longitude as double;
    });
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
          child: (lat == 0.0 && long == 0.0)
              ? Text(
                  "No location Choesen ",
                  textAlign: TextAlign.center,
                )
              // : Image.network(
              //     _previewImageUrl,
              //     fit: BoxFit.cover,
              //     width: double.infinity,
              //   ),
              : Container(
                  child: MapHelper().printMap(lat,long),
                  // child: Text("sdsdsdsds"),
                ),
        ),
        Text("Your Location is : latitude  $lat  longitude : $long "),
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
                onPressed: null),
          ],
        ),
      ],
    );
  }
}
