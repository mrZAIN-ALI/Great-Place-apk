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


  void addPlace(String pickedtitle, File capturedImage) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: capturedImage,
      location: Location(
        latitude: 0,
        longitude: 0,
        adress: "default adress",
      ),
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
            location: Location(
              latitude: 0,
              longitude: 0,
              adress: "default adress",
            ),
            image: File(
              item["image"],
            ),
          ),
        )
        .toList();
  }
}
