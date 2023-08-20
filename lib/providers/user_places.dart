import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/models/place.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(String title,File image,PlaceLocation location) async{
    // storing image locally
    final appDir= await syspaths.getApplicationDocumentsDirectory();
    final filename=path.basename(image.path);
    final copiedimage=await image.copy('${appDir.path}/$filename');

    final newplace = Place(title: title,image:copiedimage,location: location);
    state = [...state, newplace];
  }
}
final userplacesprovider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
        (ref) => UserPlacesNotifier());
