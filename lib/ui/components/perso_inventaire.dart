import 'package:flutter/widgets.dart';

import '../../data/models/item.dart';

class PersoInventaire extends StatelessWidget{
  final List<Item> item;

  const PersoInventaire({
    super.key,
    required this.item
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("inventaire"),
        Expanded(
          child: item.isEmpty
              ? const Center(child: Text('Inventaire vide'))
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: item.length,
            itemBuilder: (context, index) {
              return Text(item[index].name);
            },
          ),
        ),
      ],
    );
  }
}