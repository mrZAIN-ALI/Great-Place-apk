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
  bool _islocationPicked = false;
  @override
  Widget build(BuildContext context) {
    var curretnPos =
        Provider.of<LivePostionOfDevice>(context).get_currentPostion();
    var currentCordinates = LatLng(curretnPos.latitude, curretnPos.longitude);
    _islocationPicked =
        Provider.of<LivePostionOfDevice>(context).isLocationPicked();
    //
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Location"),
        actions: [
          IconButton(
            color: _islocationPicked==false ?  Color(0xFFA0BFE0) : const Color.fromARGB(255, 243, 185, 9) ,
            onPressed: () {
              _islocationPicked == false
                  ? null
                  : {
                      Navigator.of(context).pop(),
                      Provider.of<LivePostionOfDevice>(context, listen: false)
                          .toggleLocationBool()
                    };
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: RenderMap(
        cordinates: currentCordinates,
        preview_Window: false,
      ),
    );
  }
}
