import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:favorite_places/models/place.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key,required this.onSelectLocaction}) : super(key: key);
  final void Function(PlaceLocation location) onSelectLocaction;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  @override

  PlaceLocation? pickedLocation;
  var isgettinglocation = false;

  String get locationImage{
    if(pickedLocation==null){
      return "";
    }
    final lat=pickedLocation!.latitude;
    final long=pickedLocation!.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=AIzaSyBS-TMS4UDZxX75YPzSEpdS5md50-f8udY" ;
  }

  void saveplace(double latitude,double longitude)async {
    final url=Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyBS-TMS4UDZxX75YPzSEpdS5md50-f8udY");
    final response=await http.get(url);
    final resdata=json.decode(response.body);
    final add=resdata['results'][0]['formatted_address'];

    setState(() {
      pickedLocation=PlaceLocation(latitude: latitude!, longitude: longitude!, address: add);
      isgettinglocation = false;
    });
    widget.onSelectLocaction(pickedLocation!);
  }
  void getcurrentlocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isgettinglocation = true;
    });
    locationData = await location.getLocation();
    final lat=locationData.latitude;
    final long=locationData.longitude;

    if(lat ==null && long == null){
      return;
    }
   saveplace(lat!, long!);
  }
  void onselectmap()async {
   final pickedlocation=await Navigator.of(context).push<LatLng>(MaterialPageRoute(builder: (ctx)=> const MapScreen() ));

   if(pickedLocation==null){
     return;
   }
   saveplace(pickedlocation!.latitude,pickedlocation!.longitude);
  }
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "Location not chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );
    if(pickedLocation!= null){
      previewContent=Image.network(locationImage,fit: BoxFit.cover,height: double.infinity,width: double.infinity,);
    }
    if (isgettinglocation) {
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: Theme.of(context).primaryColor.withOpacity(1))),
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: getcurrentlocation,
                icon: const Icon(Icons.location_on),
                label: const Text("Get Your Current Location")),
            TextButton.icon(
                onPressed: onselectmap,
                icon: const Icon(Icons.map),
                label: const Text("Select on map")),
          ],
        ),
      ],
    );
  }
}
