import 'package:flutter/widgets.dart';

import '../../data/models/item.dart';
import 'card/item_card.dart';

class PersoInventaire extends StatelessWidget{
  final List<Item> item;

  const PersoInventaire({
    super.key,
    required this.item
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: item.isEmpty
              ? const Center(child: Text('Inventaire vide'))
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: item.length,
            itemBuilder: (context, index) {
              final items = item[index];
              return ItemCard(
                item: items,
                //onDelete: () => onDelete(item[index].id!),
                //onEdit: onEdit
              );
            },
          ),
        ),
      ],
    );
  }
}