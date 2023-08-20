import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/models/place.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(String title,File image,PlaceLocation location) async{
    // storing image locally
    final appDir= await syspaths.getApplicationDocumentsDirectory();
    final filename=path.basename(image.path);
    final copiedimage=await image.copy('${appDir.path}/$filename');

    final newplace = Place(title: title,image:copiedimage,location: location);
    // retrieves path to a database or create a directory for a database
    final dbpath=await sql.getDatabasesPath();
    // combining paths and creating structure of database.
    final db=await sql.openDatabase(path.join(dbpath,'places.db'),onCreate: (db, version) {
      return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT,lat REAL,long REAL,address TEXT)');
    },
    version: 1);
    // inserting the values in database
    db.insert('user_places',{
      'id':newplace.id,
      'title':newplace.title,
      'image':newplace.image,
      'lat':newplace.location.latitude,
      'long':newplace.location.longitude,
      'address':newplace.location.address
    });



    state = [...state, newplace];
  }
}
final userplacesprovider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
        (ref) => UserPlacesNotifier());
