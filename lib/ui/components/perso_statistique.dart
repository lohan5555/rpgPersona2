import 'package:flutter/material.dart';

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
              itemCount: _stats.length,
              onReorder: (oldIndex, newIndex) {

                setState(() {
                  if (newIndex > oldIndex) newIndex--;

                  final item = _stats.removeAt(oldIndex);
                  _stats.insert(newIndex, item);
                });

                for (int i = 0; i < _stats.length; i++) {
                  widget.onEdit(
                      _stats[i].copyWith(listPosition: i)
                  );
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
