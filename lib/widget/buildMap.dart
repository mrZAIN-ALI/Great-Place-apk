import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BuildMap extends StatelessWidget {
  late LatLng _selectedLocation;
  final Default_Lat = 31.57043574981514;
  final default_Long = 74.30812551224875;
  // const BuildMap({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(Default_Lat, default_Long),
        zoom: 15,
        onTap: (tapPosition, point) {
          _selectedLocation = point;
          print(_selectedLocation.latitude);
          print(_selectedLocation.longitude);

        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        
        MarkerLayer(

          markers: [
            Marker(
              width: 45.0,
              height: 45.0,
              point: LatLng(Default_Lat, default_Long),
              builder: (context) => Container(
                child: Icon(
                  Icons.location_pin,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
