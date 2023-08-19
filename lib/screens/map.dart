import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {Key? key,
      this.location = const PlaceLocation(
          latitude: 37.422, longitude: -122.084, address: ''),
      this.isSelecting = true})
      : super(key: key);
  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? pickedlocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? "Pick Your Location" : "Your Location"),
        actions: [
          if (widget.isSelecting)
            IconButton(onPressed: () {
              Navigator.of(context).pop(pickedlocation);
            }, icon: const Icon(Icons.save))
        ],
      ),
      body: GoogleMap(
        onTap:widget.isSelecting == false ? null :(position){
          setState(() {
            pickedlocation=position;
          });
        },
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.location.latitude, widget.location.longitude),
            zoom: 16),
        markers:(pickedlocation==null && widget.isSelecting==true ) ?{} : {
          Marker(
              markerId: const MarkerId("m1"),
              position:
              pickedlocation ?? LatLng( widget.location.latitude, widget.location.longitude))
        },
      ),
    );
  }
}
