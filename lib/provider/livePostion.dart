import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';

class LivePostionOfDevice extends ChangeNotifier{
    String _adress="defaultAdress";
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

  bool _isLocationPicked=false;

  Position  get_currentPostion(){
    return currentPostion;
  }
  void  update_Pos(Position pos){
    currentPostion=pos;
    notifyListeners();
  }
    void  setDefalutPos(Position pos){
    currentPostion=pos;
  }

  void toggleLocationBool(){
    _isLocationPicked=!_isLocationPicked;
    notifyListeners();
  }
  bool isLocationPicked(){
    return _isLocationPicked;
  }

  
    Future<void> getAddressFromCoordinates(Position pos) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        
          _adress = placemark.name.toString() ;
        
      } else {
        
          _adress = 'Address not found';
        
      }
    } catch (e) {
   
        _adress = 'Error: Unable to get address';
      print('Error: $e');
    }
  }   

    Future<void> getAdressName() async{

      return await getAddressFromCoordinates(currentPostion).then((value) => _adress);

    }
}