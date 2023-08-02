import 'package:flutter/material.dart';
import 'package:great_place/helpers/locationHelper.dart';
import 'package:great_place/provider/livePostion.dart';
import 'package:location/location.dart';
import 'dart:io';
import 'package:provider/provider.dart';
//
import '../widget/image_input.dart';
import '../provider/greatPlace.dart';
import '../widget/location_input.dart';
import '../models/place.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});
  static const routeName = "/add-place-screen";

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;

  void _selectImage(File selectedImage) {
    _selectedImage = selectedImage;
  }

  Future<void> _savePlace() async {
    final pos = Provider.of<LivePostionOfDevice>(context, listen: false)
        .get_currentPostion();
    final address = await LocationHelper.getAddress(pos);
    if (_titleController.text.isEmpty ||
        _titleController.text == null ||
        pos == null) {
      print(
        "Cannot save place title is either empty or null or postion is null",
      );
      return;
    }
    Provider.of<GreatPlace>(context, listen: false).addPlace(
      _titleController.text,
      _selectedImage as File,
      PlaceLocation(
          latitude: pos.latitude, longitude: pos.longitude, adress: address),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a New Place"),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectImage),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(),
                  ],
                ),
              ),
            ),
          ),
          FloatingActionButton.extended(
            heroTag: "Add Place Button",
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: Icon(
              Icons.add,
            ),
            label: Text("Add Place"),
            onPressed: _savePlace,
          )
        ],
      ),
    );
  }
}
