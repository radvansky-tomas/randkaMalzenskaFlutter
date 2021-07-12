import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableName = 'words';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnContent = 'content';

// data model class
class Note {
  int? id;
  String? title;
  String? content;

  Note();

  // convenience constructor to create a Note object
  Note.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    content = map[columnContent];
  }

  // convenience method to create a Map from this Note object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnTitle: title, columnContent: content};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
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
              CREATE TABLE $tableName (
                $columnId INTEGER PRIMARY KEY,
                $columnTitle TEXT NOT NULL,
                $columnContent TEXT NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Note note) async {
    Database db = await database;
    int id = await db.insert(tableName, note.toMap());
    return id;
  }

  Future<List<Note>?> queryNote() async {
    Database db = await database;
    List<Map> maps = await db.query(
      tableName,
      columns: [columnId, columnTitle, columnContent],
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

  Future<int?> getCount() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.query('SELECT COUNT(*) FROM $tableName'));
  }
}
