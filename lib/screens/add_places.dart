import 'package:favorite_places/widgets/imageinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}
class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final titlecontroller = TextEditingController();
  File? selectedimage;
  void saveplace(){
    final enteredtitle=titlecontroller.text;
    if(enteredtitle.isEmpty || selectedimage==null){
      return;
    }
    ref.read(userplacesprovider.notifier).addPlace(enteredtitle,selectedimage!);
    Navigator.of(context).pop();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titlecontroller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Places"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              controller: titlecontroller,
              keyboardType:TextInputType.text,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),const SizedBox(
              height: 16,
            ),
            ImageInput(onpickedimage: (image){
              selectedimage=image;
            },),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
                onPressed: saveplace,
                icon: const Icon(Icons.add),
                label: const Text("Add Place"))
          ],
        ),
      ),
    );
  }
}
