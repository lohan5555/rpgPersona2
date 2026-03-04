import 'package:rpg_persona2/data/models/perso.dart';
import 'package:sqflite/sqflite.dart';

import '../data/db.dart';

class PersoService{

  Future<int> insertPerso(Perso perso) async {
    final db = await DatabaseService.database;

    return await db!.insert(
      'perso',
      perso.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Perso>> getAllperso() async {
    final db = await DatabaseService.database;

    final List<Map<String, Object?>> persoMaps = await db!.query('perso');

    return [
      for (final map in persoMaps)
        Perso(
          id: map['id'] as int,
          name: map['name'] as String,
          desc: map['desc'] as String?,
          note: map['note'] as String?,
          listPosition: map['listPosition'] as int,
          imgPath: map['imgPath'] as String?,
          partieId: map['partieId'] as int
        ),
    ];
  }

  Future<List<Perso>> getAllpersoByPartie(int partieId) async {
    final db = await DatabaseService.database;

    final List<Map<String, Object?>> persoMaps = await db!.query('perso',
        where: 'partieId = ?',
        whereArgs: [partieId],
        orderBy: 'listPosition ASC',
    );

    return [
      for (final map in persoMaps)
        Perso(
            id: map['id'] as int,
            name: map['name'] as String,
            desc: map['desc'] as String?,
            note: map['note'] as String?,
            listPosition: map['listPosition'] as int,
            imgPath: map['imgPath'] as String?,
            partieId: map['partieId'] as int
        ),
    ];
  }

  Future<void> deletePerso(int id) async {
    final db = await DatabaseService.database;

    await db?.delete(
      'perso',
      where: 'id = ?',
      whereArgs: [id], //to prevent SQL injection.
    );
  }

  Future<void> updatePerso(Perso perso) async {
    final db = await DatabaseService.database;

    await db?.update(
      'perso',
      perso.toMap(),
      where: 'id = ?',
      whereArgs: [perso.id],
    );
  }


}