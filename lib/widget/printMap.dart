import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';
//
import '../provider/livePostion.dart';

class RenderMap extends StatefulWidget {
  final preview_Window;
  LatLng cordinates;
  
  //
  RenderMap({
    required this.cordinates,
    required this.preview_Window,
  });

  @override
  State<RenderMap> createState() => _RenderMapState();
}

class _RenderMapState extends State<RenderMap> {
  //
  List<String> _suggestions = [];
  FloatingSearchBarController _floatController = FloatingSearchBarController();
  MapController _mapController = MapController();
  StreamSubscription<Position>? positionStream; // Define the subscription

  //
  @override
  void dispose() {
    // Cancel the stream subscription when the widget is disposed
    positionStream?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(RenderMap oldWidget) {
    // TODO: implement didChangeDependencies

    super.didUpdateWidget(oldWidget);
    if (widget.cordinates != oldWidget.cordinates) {
      _mapController.move(widget.cordinates, 15);
    }
    // super.didChangeDependencies();
  }

  void updatePostioninProvider(LatLng ps) {
    Position currentPostion = Position(
      longitude: ps.longitude,
      latitude: ps.latitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
    );
    Provider.of<LivePostionOfDevice>(context, listen: false)
        .update_Pos(currentPostion);
    setState(() {
      widget.cordinates = ps;
    });
    
    print("Printing from postion provider : ${ps.latitude}");
  }

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
    // positionStream?.cancel();

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? pos) {
      print(pos == null
          ? 'Unknown'
          : '${pos.latitude.toString()}, ${pos.longitude.toString()}');
      // setState(() {
      //   _currentPostion=pos;
      //   _cordinates = LatLng(_currentPostion!.latitude,_currentPostion!.longitude);

      // });
      Provider.of<LivePostionOfDevice>(context, listen: false)
          .update_Pos(pos as Position);
      setState(() {
        widget.cordinates = LatLng(pos!.latitude, pos!.longitude);
      });
      _mapController.move(widget.cordinates, 15);
      print("returning HEHE locaiton ${widget.cordinates}");
    });
  }

  Future<void> resetToYourCuurrentLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update the position in the provider and the widget state
      updatePostioninProvider(LatLng(pos.latitude, pos.longitude));
      _mapController.move(widget.cordinates, 15);
      print("Returning one time location ${pos.toString()}");
    } catch (e) {
      print("Error while fetching current location: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            
            onTap: widget.preview_Window==true ?  (tapPosition, point) {
              updatePostioninProvider(point);
            } : null,
            center: widget.cordinates,
            zoom: 9.2,
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
                  point: widget.cordinates,
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
        ),
        // widget.preview_Window == true ?
        if (!widget.preview_Window) buildFloatingSearchBar(),
        // Text(" ${widget.cordinates.toString()}")
      ],
    );
  }

  Widget buildFloatingSearchBar() {
    return FloatingSearchBar(
      controller: _floatController,
      hint: 'Search locations...',
      scrollPadding: const EdgeInsets.only(top: 16.0),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      openAxisAlignment: 0.0,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        if (query.isNotEmpty) {
          _fetchSuggestions(query).then((suggestions) {
            setState(() {
              _suggestions = suggestions;
            });
          }).catchError((error) {
            print(error);
          });
        } else {
          setState(() {
            _suggestions = [];
          });
        }
      },
      actions: [
        FloatingSearchBarAction.icon(
          icon: Icons.place,
          onTap: () {
            resetToYourCuurrentLocation();
            _getCurrentUserLocation();
          },
        ),
        FloatingSearchBarAction.searchToClear(),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _suggestions[index];
                    return ListTile(
                      title: Text(suggestion),
                      onTap: () {
                        _selectSuggestion(index);
                        _floatController.close();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<String>> _fetchSuggestions(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Decode the response body using the correct character encoding (UTF-8)
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((place) => place['display_name'] as String).toList();
    } else {
      throw Exception("Failed to fetch suggestions");
    }
  }

  //work
  Future<List<MapLocation>> _fetchPlaces(String query) async {
    final url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((place) => MapLocation.fromJson(place)).toList();
    } else {
      throw Exception("Failed to fetch places");
    }
  }

  //work
  void _selectSuggestion(int index) async {
    if (index >= 0 && index < _suggestions.length) {
      final selectedSuggestion = _suggestions[index];
      print("Selected suggestion: $selectedSuggestion");

      final places = await _fetchPlaces(selectedSuggestion);
      if (places.isNotEmpty) {
        final selectedLocation = places[0];
        updatePostioninProvider(
          LatLng(selectedLocation.latitude, selectedLocation.longitude),
        );
        // print("hehehe lo l ${widget.cordinates.toString()}");
        _mapController.move(widget.cordinates, 15);
      }
      Provider.of<LivePostionOfDevice>(context,listen: false).toggleLocationBool();
      setState(() {
        _suggestions.clear();
      });
    }
  }
}

class MapLocation {
  final double latitude;
  final double longitude;
  final String displayName;
  final String? address;

  MapLocation({
    required this.latitude,
    required this.longitude,
    required this.displayName,
    this.address,
  });

  factory MapLocation.fromJson(Map<String, dynamic> json) {
    // Handle any errors that may occur during parsing
    double parseDouble(dynamic value) {
      if (value is double) {
        return value;
      } else if (value is String) {
        return double.tryParse(value) ?? 0.0;
      } else {
        return 0.0;
      }
    }

    return MapLocation(
      latitude: parseDouble(json['lat']),
      longitude: parseDouble(json['lon']),
      displayName: json['display_name'],
      address: json['address'] != null ? json['address']['formatted'] : null,
    );
  }
}

Future<List<MapLocation>> _fetchPlaces(String query) async {
  final url =
      "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((place) => MapLocation.fromJson(place)).toList();
  } else {
    throw Exception("Failed to fetch places");
  }
}
