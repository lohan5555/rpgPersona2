import 'package:flutter/material.dart';

import '../../../data/models/item.dart';

class ItemCard extends StatefulWidget {
  final Item item;
  //final VoidCallback onDelete;
  //final void Function(Stat) onEdit;

  const ItemCard({
    super.key,
    required this.item,
    //required this.onDelete,
    //required this.onEdit
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard>{

  bool focusCard = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 0),
      shape: ContinuousRectangleBorder(),
      child:Column(
        children: [
          InkWell(
            onLongPress: () {
              print("long tap");
            },
            onTap: () {
              setState(() {
                focusCard = !focusCard;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (focusCard && widget.item.desc != null && widget.item.desc!.isNotEmpty) ...[
                          Text(
                            widget.item.desc!,
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.remove), iconSize: 15),
                      Text(widget.item.quantity.toString()),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.add), iconSize: 15),
                    ],
                  ),
                ],
              )
            ),
          ),
          Divider(height: 0)
        ],
      )
    );
  }

}