import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
//
import '../provider/greatPlace.dart';
import '../widget/printMap.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key});
  static const routeName = "/place-details";

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final selectedPlace =
        Provider.of<GreatPlace>(context).findByid(id as String);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            selectedPlace.location.adress,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
          TextButton(
            child: Text("View On Map"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => Scaffold(
                  appBar: AppBar(title: Text("Map View"),),
                  body: RenderMap(
                      cordinates: LatLng(selectedPlace.location.latitude,
                          selectedPlace.location.longitude),
                      preview_Window: true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
