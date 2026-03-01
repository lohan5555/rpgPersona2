import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseService {
  static sql.Database? _database;

  static Future<sql.Database?> get database async {
    if (_database != null) return _database!;

    _database = await sql.openDatabase(
      join(await sql.getDatabasesPath(), 'plantoune.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE partie(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            desc TEXT,
            note TEXT,
            imgPath TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE perso(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            desc TEXT,
            note TEXT,
            partieId INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE stat(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            valeur FLOAT,
            persoId INTEGER
          )
        ''');
      },
    );
    return _database;
  }
}