import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;

class ImageInput extends StatefulWidget {
  final Function _selectImageFun;
  ImageInput(this._selectImageFun,);
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takeImage() async {
    final piceker = ImagePicker();
    final imageFile = await piceker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      maxHeight: 600
    );
    if(imageFile== null){
      print("Image not recived from camera");
      return;
      
    }
    setState(() {
      _storedImage=File(imageFile!.path);
    });
    final appDir= await sysPath.getApplicationDocumentsDirectory();
    final fileName= path.basename(imageFile!.path);
    final savedImage  = await imageFile.saveTo("${appDir.path}/$fileName");

    widget._selectImageFun(_storedImage,);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage as File,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  "No Image Taken",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        
        SizedBox(height: 10,),

           Container(
            margin: EdgeInsets.all(10),
             child: FloatingActionButton.extended(
              label: Text("Take Photo"),
              icon: Icon(Icons.camera),
              onPressed: () {
                _takeImage();
              },
                     ),
           ),
        
      ],
    );
  }
}
