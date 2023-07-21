import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
//
import '../widget/image_input.dart';
import '../provider/greatPlace.dart';
import '../widget/location_input.dart';

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

  void _savePlace() {
    if (_titleController.text.isEmpty || _titleController.text == null) {
      print(
        "Cannot save place title is either empty or null",
      );
      return;
    }
    Provider.of<GreatPlace>(context, listen: false)
        .addPlace(_titleController.text, _selectedImage as File);
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
                    SizedBox(height: 10,),
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
