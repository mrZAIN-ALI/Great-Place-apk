import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
class MapHelper {

  FlutterMap printMap(double lat, double long) {
    return FlutterMap(
      options: MapOptions(
        
        center: LatLng(lat, long),
        zoom: 15.0,
      ),
          // nonRotatedChildren: [
      // RichAttributionWidget(
      //   attributions: [
      //     TextSourceAttribution(
      //       'OpenStreetMap contributors',
      //       onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
      //     ),
      //   ],
      // ),
    // ],
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
                      point: LatLng(lat, long),
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