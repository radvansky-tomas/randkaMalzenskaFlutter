import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// note table
final String noteTableName = 'words';
final String columnId = '_id';
final String noteColumnTitle = 'title';
final String noteColumnContent = 'content';

// photo table
final String photoTableName = 'photos';
final String photoColumnPath = 'path';
final String photoPrimaryOrder = 'primaryOrder';
final String photoSecondaryOrder = 'secondaryOrder';

// note model class
class Note {
  int? id;
  String? title;
  String? content;

  Note();

  // convenience constructor to create a Note object
  Note.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[noteColumnTitle];
    content = map[noteColumnContent];
  }

  // convenience method to create a Map from this Note object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      noteColumnTitle: title,
      noteColumnContent: content
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// photo model class
class Photo {
  int? id;
  String? path;
  int? primaryOrder;
  int? secondaryOrder;

  Photo();

  // convenience constructor to create a Photo object
  Photo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    path = map[photoColumnPath];
    primaryOrder = map[photoPrimaryOrder];
    secondaryOrder = map[photoSecondaryOrder];
  }

  // convenience method to create a Map from this Photo object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      photoColumnPath: path,
      photoPrimaryOrder: primaryOrder,
      photoSecondaryOrder: secondaryOrder,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase6.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $noteTableName (
                $columnId INTEGER PRIMARY KEY,
                $noteColumnTitle TEXT NOT NULL,
                $noteColumnContent TEXT NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE $photoTableName (
                $columnId INTEGER PRIMARY KEY,
                $photoColumnPath TEXT NOT NULL,
                $photoPrimaryOrder INTEGER,
                $photoSecondaryOrder INTEGER             
              )
              ''');
  }

  // Database helper methods:

  Future<int> insertNote(Note note) async {
    Database db = await database;
    int id = await db.insert(noteTableName, note.toMap());
    return id;
  }

  Future<int> insertPhoto(Photo photo) async {
    Database db = await database;
    int id = await db.insert(photoTableName, photo.toMap());
    return id;
  }

  Future<int> insertOrUpdatePhoto(Photo photo) async {
    Database db = await database;
    int id;
    Photo? photoDb =
        await queryPhotoByPosition(photo.primaryOrder!, photo.secondaryOrder!);
    if (photoDb != null) {
      id = await db.update(photoTableName, photo.toMap(),
          where: '$columnId = ?', whereArgs: [photoDb.id]);
    } else {
      id = await db.insert(photoTableName, photo.toMap());
    }

    return id;
  }

  Future<List<Note>?> queryNote() async {
    Database db = await database;
    List<Map> maps = await db.query(
      noteTableName,
      columns: [columnId, noteColumnTitle, noteColumnContent],
    );
    List<Note> notes = [];
    if (maps.length > 0) {
      maps.forEach((result) {
        Note note = Note.fromMap(result as Map<String, dynamic>);
        notes.add(note);
      });
      return notes;
    }
    return null;
  }

  Future<List<Photo>?> queryPhoto() async {
    Database db = await database;
    List<Map> maps = await db.query(
      photoTableName,
      columns: [columnId, photoColumnPath],
    );
    List<Photo> photos = [];
    if (maps.length > 0) {
      maps.forEach((result) {
        Photo photo = Photo.fromMap(result as Map<String, dynamic>);
        photos.add(photo);
      });
      return photos;
    }
    return null;
  }

  Future<Photo?> queryPhotoByPosition(
      int primaryOrder, int secondaryOrder) async {
    Database db = await database;
    String whereString = '$photoPrimaryOrder = ? AND $photoSecondaryOrder = ?';
    List<dynamic> whereArguments = [primaryOrder, secondaryOrder];
    List<Map> maps = await db.query(photoTableName,
        columns: [
          columnId,
          photoColumnPath,
          photoPrimaryOrder,
          photoSecondaryOrder
        ],
        where: whereString,
        whereArgs: whereArguments);
    List<Photo> photos = [];
    if (maps.length > 0) {
      maps.forEach((result) {
        Photo photo = Photo.fromMap(result as Map<String, dynamic>);
        photos.add(photo);
      });
      return photos[0];
    }
    return null;
  }

  Future updateNote(Map<String, dynamic> note) async {
    Database db = await database;
    await db.update(noteTableName, note,
        where: '$columnId = ?', whereArgs: [note['$columnId']]);
  }

  Future deleteNote(int id) async {
    Database db = await database;
    await db.delete(noteTableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int?> getNoteCount() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.query('SELECT COUNT(*) FROM $noteTableName'));
  }
}
