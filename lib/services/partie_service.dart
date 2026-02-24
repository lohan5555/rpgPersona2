
import 'package:rpg_persona2/data/models/partie.dart';
import 'package:sqflite/sqflite.dart';

import '../data/db.dart';

class PartieService{

  Future<int> insertPartie(Partie partie) async {
    final db = await DatabaseService.database;

    return await db!.insert(
      'partie',
      partie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Partie>> getAllpartie() async {
    final db = await DatabaseService.database;

    final List<Map<String, Object?>> partieMaps = await db!.query('partie');

    return [
      for (final map in partieMaps)
        Partie(
          id: map['id'] as int,
          name: map['name'] as String,
          desc: map['desc'] as String?,
          dateDebut: DateTime.parse(map['dateDebut'] as String),
          dateFin: DateTime.parse(map['dateFin'] as String),
        ),
    ];
  }

  Future<void> deletePartie(int id) async {
    final db = await DatabaseService.database;

    await db?.delete(
      'partie',
      where: 'id = ?',
      whereArgs: [id], //to prevent SQL injection.
    );
  }


}