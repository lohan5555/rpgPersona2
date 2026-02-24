import 'package:sqflite/sqflite.dart';

import '../data/db.dart';
import '../data/models/stat.dart';

class StatService{

  Future<int> insertStat(Stat stat) async {
    final db = await DatabaseService.database;

    return await db!.insert(
      'stat',
      stat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Stat>> getAllstat() async {
    final db = await DatabaseService.database;

    final List<Map<String, Object?>> statMaps = await db!.query('stat');

    return [
      for (final map in statMaps)
        Stat(
            id: map['id'] as int,
            name: map['name'] as String,
            valeur: map['valeur'] as double,
            persoId: map['persoId'] as int
        ),
    ];
  }

  Future<List<Stat>> getAllStatByPerso(int persoId) async {
    final db = await DatabaseService.database;

    final List<Map<String, Object?>> statMap = await db!.query('stat',
        where: 'persoId = ?',
        whereArgs: [persoId]
    );

    return [
      for (final map in statMap)
        Stat(
            id: map['id'] as int,
            name: map['name'] as String,
            valeur: map['valeur'] as double,
            persoId: map['persoId'] as int
        ),
    ];
  }

  Future<void> deleteStat(int id) async {
    final db = await DatabaseService.database;

    await db?.delete(
      'stat',
      where: 'id = ?',
      whereArgs: [id], //to prevent SQL injection.
    );
  }


}