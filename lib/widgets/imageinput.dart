import 'dart:ffi';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({Key? key}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? selectedimage;

  void takepicture() async {
    final imagepicker = ImagePicker();
    final pickedImage = await imagepicker.pickImage(
        source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      selectedimage = File(pickedImage.path);
    });
    //selectedimage = File(pickedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      icon: const Icon(Icons.camera),
      label: const Text("Take your Picture"),
      onPressed: takepicture,
    );
    if (selectedimage != null) {

        content = GestureDetector(
          onTap:takepicture ,
          child: Image.file(selectedimage!, fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,),
        );
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Theme
                  .of(context)
                  .primaryColor
                  .withOpacity(1))),
      height: 250,
      width: double.infinity,
      child: content,
    );
  }
}
