import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

//
import '../widget/buildMap.dart';

class CustomLocSelection extends StatefulWidget {
  const CustomLocSelection({super.key});

  @override
  State<CustomLocSelection> createState() => _CustomLocSelectionState();
}

class _CustomLocSelectionState extends State<CustomLocSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),

        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: Icon(Icons.done),),
        ],
      ),

      body: BuildMap(),
    );
  }
}
class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController _mapController = MapController();
  LatLng ?_selectedLocation;

  void _handleTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenStreetMap Location Picker'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(37.7749, -122.4194), // Initial map center (San Francisco)
          zoom: 13.0, // Initial map zoom level
          onTap: _handleTap , // Callback for map taps
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _selectedLocation != null
                ? [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: _selectedLocation  as LatLng,
                      builder: (context) => Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
                  ]
                : [],
          ),
        ],
      ),
    );
  }
}