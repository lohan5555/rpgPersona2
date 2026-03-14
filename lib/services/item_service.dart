import 'package:sqflite/sqflite.dart';

import '../data/db.dart';
import '../data/models/item.dart';

class ItemService{

  Future<int> insertItem(Item item) async {
    final db = await DatabaseService.database;

    return await db!.insert(
      'item',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Item>> getAllItem() async {
    final db = await DatabaseService.database;

    final List<Map<String, Object?>> itemMaps = await db!.query('item');

    return [
      for (final map in itemMaps)
        Item(
            id: map['id'] as int,
            name: map['name'] as String,
            quantity: map['quantity'] as int,
            desc: map['desc'] as String?,
            listPosition: map['listPosition'] as int,
            persoId: map['persoId'] as int
        ),
    ];
  }

  Future<List<Item>> getAllItemByPerso(int persoId) async {
    final db = await DatabaseService.database;

    final List<Map<String, Object?>> itemMap = await db!.query('item',
        where: 'persoId = ?',
        whereArgs: [persoId],
        orderBy: 'listPosition ASC'
    );

    return [
      for (final map in itemMap)
        Item(
            id: map['id'] as int,
            name: map['name'] as String,
            quantity: map['quantity'] as int,
            desc: map['desc'] as String?,
            listPosition: map['listPosition'] as int,
            persoId: map['persoId'] as int
        ),
    ];
  }

  Future<void> deleteItem(int id) async {
    final db = await DatabaseService.database;

    await db?.delete(
      'item',
      where: 'id = ?',
      whereArgs: [id], //to prevent SQL injection.
    );
  }

  Future<void> updateItem(Item item) async {
    final db = await DatabaseService.database;

    await db?.update(
      'item',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> updateItemListPosition() async {
    final db = await DatabaseService.database;
    if (db == null) return;

    final List<Item> items = await getAllItem();

    // Un Batch pour tout mettre à jour d'un coup
    final batch = db.batch();

    for (int i = 0; i < items.length; i++) {
      final itemMiseAJour = items[i].copyWith(listPosition: i);

      batch.update(
        'item',
        itemMiseAJour.toMap(),
        where: 'id = ?',
        whereArgs: [itemMiseAJour.id],
      );
    }

    // Exécuter toutes les mises à jour en une seule fois
    await batch.commit(noResult: true);
  }


}