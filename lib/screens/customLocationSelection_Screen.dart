import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:great_place/widget/printMap.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

//
import '../widget/buildMap.dart';
import '../provider/livePostion.dart';

class CustomLocSelection extends StatefulWidget {
  // const CustomLocSelection({super.key});

  @override
  State<CustomLocSelection> createState() => _CustomLocSelectionState();
}

class _CustomLocSelectionState extends State<CustomLocSelection> {
  @override
  Widget build(BuildContext context) {
    var curretnPos= Provider.of<LivePostionOfDevice>(context).get_currentPostion();
    var currentCordinates=LatLng(curretnPos.latitude, curretnPos.longitude);
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Location"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: RenderMap(cordinates: currentCordinates, preview_Window: false),
    );
  }
}
