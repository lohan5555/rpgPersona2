import 'package:flutter/material.dart';

import '../../data/models/item.dart';
import 'card/item_card.dart';

class PersoInventaire extends StatefulWidget {
  final List<Item> items;
  final void Function(int) onDelete;
  final Future<void> Function(Item) onEdit;

  const PersoInventaire({
    super.key,
    required this.items,
    required this.onDelete,
    required this.onEdit
  });

  @override
  State<PersoInventaire> createState() => _PersoInventaireState();
}

class _PersoInventaireState extends State<PersoInventaire> {

  late List<Item> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
  }

  // Cette méthode est appelée par Flutter à chaque fois que le widget "parent"
  // envoie de nouvelles données
  @override
  void didUpdateWidget(covariant PersoInventaire oldWidget) {
    super.didUpdateWidget(oldWidget);
    _items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _items.isEmpty
              ? const Center(child: Text('Inventaire vide'))
              : ReorderableListView.builder(
            proxyDecorator: (Widget child, int index, Animation<double> animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget? child) {
                  return Material(
                    color: Colors.transparent,
                    child: child,
                  );
                },
                child: child,
              );
            },
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: _items.length,
            onReorder: (oldIndex, newIndex) {

              setState(() {
                if (newIndex > oldIndex) newIndex--;

                final item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });

              for (int i = 0; i < _items.length; i++) {
                  widget.onEdit(
                    _items[i].copyWith(listPosition: i)
                );
              }
            },
            itemBuilder: (context, index) {
              final item = _items[index];

              return ItemCard(
                key: ValueKey(item.id),
                item: item,
                onDelete: () => widget.onDelete(item.id!),
                onEdit: widget.onEdit,
              );
            },
          ),
        ),
      ],
    );
  }
}