import 'package:flutter/widgets.dart';

import '../../data/models/stat.dart';
import 'card/stat_card.dart';

class PersoStatistique extends StatelessWidget{
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: stat.isEmpty
              ? const Center(child: Text('Aucune statistique'))
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: stat.length,
            itemBuilder: (context, index) {
              final stats = stat[index];
              return StatCard(
                  stat: stats,
                  onDelete: () => onDelete(stat[index].id!),
                  onEdit: onEdit);
            },
          ),
        ),
      ],
    );
  }
}
