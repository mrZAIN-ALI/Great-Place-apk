import 'package:flutter/material.dart';
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

    DBHelper.insert("places", {
      "id" :newPlace.id,
      "title" : newPlace.title,
      "image" : newPlace.image.path,
    },);
  }
}
