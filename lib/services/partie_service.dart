
import 'dart:io';

import 'package:rpg_persona2/data/models/partie.dart';
import 'package:sqflite/sqflite.dart';

import '../data/db.dart';
import '../data/models/perso.dart';

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

    final List<Map<String, Object?>> partieMaps = await db!.query(
      'partie',
      orderBy: 'listPosition ASC');

    return [
      for (final map in partieMaps)
        Partie(
          id: map['id'] as int,
          name: map['name'] as String,
          desc: map['desc'] as String?,
          note: map['note'] as String?,
          imgPath: map['imgPath'] as String?,
          emoji: map['emoji'] as String,
          listPosition: map['listPosition'] as int
        ),
    ];
  }

  Future<void> deletePartie(int id, List<Perso> perso, Partie partie) async {
    final db = await DatabaseService.database;

    //supprime l'image de la partie
    final imgPath = partie.imgPath;
    if (imgPath != null && imgPath.contains("rpg_persona2")) {
      final file = File(imgPath);
      if (await file.exists()) {
        await file.delete();
      }
    }

    //supprime les images des perso supprimer en cascade
    for (var p in perso){
      final imgPath = p.imgPath;
      if (imgPath != null && imgPath.contains("rpg_persona2")) {
        final file = File(imgPath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }




    await db?.delete(
      'partie',
      where: 'id = ?',
      whereArgs: [id], //to prevent SQL injection.
    );
  }

  Future<void> updateParie(Partie partie, String? oldPath) async {
    final db = await DatabaseService.database;


    if (oldPath != null &&
        oldPath != partie.imgPath &&
        oldPath.contains("rpg_persona2") &&
        partie.imgPath != null) {
      final oldFile = File(oldPath);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }
    }

    await db?.update(
      'partie',
      partie.toMap(),
      where: 'id = ?',
      whereArgs: [partie.id],
    );
  }

  Future<void> updatePartieListPosition() async {
    final db = await DatabaseService.database;
    if (db == null) return;

    final List<Partie> parties = await getAllpartie();

    // Un Batch pour tout mettre à jour d'un coup
    final batch = db.batch();

    for (int i = 0; i < parties.length; i++) {
      final partieMiseAJour = parties[i].copyWith(listPosition: i);

      batch.update(
        'partie',
        partieMiseAJour.toMap(),
        where: 'id = ?',
        whereArgs: [partieMiseAJour.id],
      );
    }

    // Exécuter toutes les mises à jour en une seule fois
    await batch.commit(noResult: true);
  }


}