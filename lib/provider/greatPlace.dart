import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
//
import '../models/place.dart';
import '../helpers/db_helper.dart';

//
class GreatPlace with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }


  void addPlace(String pickedtitle, File capturedImage,PlaceLocation location) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: capturedImage,
      location: location,
      title: pickedtitle,
    );
    _items.add(newPlace);
    notifyListeners();

    DBHelper.insert(
      "user_paces",
      {
        "id": newPlace.id,
        "title": newPlace.title,
        "image": newPlace.image.path,
        "loc_lat": newPlace.location.latitude,
        "loc_lon": newPlace.location.longitude,
        "address": newPlace.location.adress,
      },
    );
  }

  Future<void> fetchAndSetDataFromDevice() async {
    final dataList = await DBHelper.getData("user_paces");
    _items = dataList
        .map(
          (item) => Place(
            id: item["id"],
            title: item["title"],
            location: PlaceLocation(
              latitude: item["loc_lat"],
              longitude: item["loc_lon"],
              adress: item["address"],
            ),
            image: File(
              item["image"],
            ),
          ),
        )
        .toList();
  }
}
