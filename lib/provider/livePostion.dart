import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

class LivePostionOfDevice extends ChangeNotifier{
    Position currentPostion = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  Position  get_currentPostion(){
    return currentPostion;
  }
  void  update_Pos(Position pos){
    currentPostion=pos;
    notifyListeners();
  }
}