import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseService {
  static sql.Database? _database;

  static Future<sql.Database?> get database async {
    if (_database != null) return _database!;

    _database = await sql.openDatabase(
      join(await sql.getDatabasesPath(), 'plantoune.db'),
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON'); // active le support des clés étrangères
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE partie(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            desc TEXT,
            note TEXT,
            imgPath TEXT,
            emoji TEXT NOT NULL,
            listPosition INT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE perso(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            desc TEXT,
            note TEXT,
            imgPath TEXT,
            listPosition INT NOT NULL,
            partieId INTEGER NOT NULL,
            FOREIGN KEY (partieId) REFERENCES partie (id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE stat(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            valeur FLOAT NOT NULL,
            persoId INTEGER NOT NULL,
            FOREIGN KEY (persoId) REFERENCES perso (id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE item(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            quantity INT NOT NULL,
            desc TEXT,
            listPosition INT NOT NULL,
            persoId INTEGER NOT NULL,
            FOREIGN KEY (persoId) REFERENCES perso (id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          INSERT INTO partie VALUES(
            1,
            'Ma super partie',
            'One shot',
            'Une aventure bien sympatique',
            NULL,
            '⚔️',
            0
          )
        ''');
        await db.execute('''
          INSERT INTO perso VALUES(
            1,
            'Bob',
            'Le Barbare',
            "Il est gentil mais j'en ferai pas un elevage",
            NULL,
            0,
            1
          )
        ''');
        await db.execute('''
          INSERT INTO stat VALUES(
            1,
            'Force',
            100,
            1
          )
        ''');
        await db.execute('''
          INSERT INTO stat VALUES(
            2,
            'Intelligence',
            0,
            1
          )
        ''');
      },
    );
    return _database;
  }
}