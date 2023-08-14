import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/widgets/places_list.dart';
class PlacesScreen extends StatelessWidget {
  const PlacesScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Places"),
        actions: [
          IconButton(onPressed:(){}, icon:Icon(Icons.add))
        ],),
      body:const PlacesList(places: [],),
    );
  }
}