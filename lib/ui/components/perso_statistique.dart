import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../data/models/stat.dart';
import 'card/stat_card.dart';

class PersoStatistique extends StatefulWidget {
  final List<Stat> stat;
  final void Function(int) onDelete;
  final void Function(Stat) onEdit;

  const PersoStatistique({
    super.key,
    required this.stat,
    required this.onDelete,
    required this.onEdit
  });

  @override
  State<PersoStatistique> createState() => _PersoStatistiqueState();
}

class _PersoStatistiqueState extends State<PersoStatistique>{

  late List<Stat> _stats;

  @override
  void initState() {
    super.initState();
    _stats = widget.stat;
  }

  @override
  void didUpdateWidget(covariant PersoStatistique oldWidget) {
    super.didUpdateWidget(oldWidget);
    _stats = widget.stat;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _stats.isEmpty
            ? const Center(child: Text('Aucune statistique'))
            : ReorderableGridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: _stats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                final item = _stats.removeAt(oldIndex);
                _stats.insert(newIndex, item);
              });
              for (int i = 0; i < _stats.length; i++) {
                widget.onEdit(_stats[i].copyWith(listPosition: i));
              }
            },
            itemBuilder: (context, index) {
              final stat = _stats[index];
              return StatCard(
                key: ValueKey(stat.id),
                stat: stat,
                onDelete: () => widget.onDelete(stat.id!),
                onEdit: widget.onEdit,
              );
            },
          ),
        ),
      ],
    );
  }
}
