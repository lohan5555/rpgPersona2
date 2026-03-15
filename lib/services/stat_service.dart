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
            listPosition: map['listPosition'] as int,
            persoId: map['persoId'] as int
        ),
    ];
  }

  Future<List<Stat>> getAllStatByPerso(int persoId) async {
    final db = await DatabaseService.database;

    final List<Map<String, Object?>> statMap = await db!.query('stat',
        where: 'persoId = ?',
        whereArgs: [persoId],
        orderBy: 'listPosition ASC',
    );

    return [
      for (final map in statMap)
        Stat(
            id: map['id'] as int,
            name: map['name'] as String,
            valeur: map['valeur'] as double,
            listPosition: map['listPosition'] as int,
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

  Future<void> updateStat(Stat stat) async {
    final db = await DatabaseService.database;

    await db?.update(
      'stat',
      stat.toMap(),
      where: 'id = ?',
      whereArgs: [stat.id],
    );
  }

  Future<void> updateStatListPosition() async {
    final db = await DatabaseService.database;
    if (db == null) return;

    final List<Stat> stats = await getAllstat();

    // Un Batch pour tout mettre à jour d'un coup
    final batch = db.batch();

    for (int i = 0; i < stats.length; i++) {
      final statMiseAJour = stats[i].copyWith(listPosition: i);

      batch.update(
        'stat',
        statMiseAJour.toMap(),
        where: 'id = ?',
        whereArgs: [statMiseAJour.id],
      );
    }

    // Exécuter toutes les mises à jour en une seule fois
    await batch.commit(noResult: true);
  }


}