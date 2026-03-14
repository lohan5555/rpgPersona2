import 'package:flutter/material.dart';

import '../../../data/models/item.dart';

class ItemCard extends StatefulWidget {
  final Item item;
  final VoidCallback onDelete;
  final void Function(Item) onEdit;

  const ItemCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onEdit
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
            onLongPress: _showDeleteStatDialog,
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
                          SizedBox(height: 5),
                          Text(
                            textAlign: TextAlign.justify,
                            widget.item.desc!,
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(onPressed: () async{
                        final editItem = widget.item.copyWith(quantity: widget.item.quantity -1);
                        widget.onEdit(editItem);
                      }, 
                      icon: const Icon(Icons.remove),
                      iconSize: 15),
                      Text(widget.item.quantity.toString()),
                      IconButton(onPressed: () async{
                        final editItem = widget.item.copyWith(quantity: widget.item.quantity +1);
                        widget.onEdit(editItem);
                      },
                      icon: const Icon(Icons.add),
                      iconSize: 15),
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

  Future<void> _showDeleteStatDialog() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Attention !'),
        content: const Text("Êtes-vous sur de vouloir supprimer cet objet de l'inventaire ? Cette action est définitive."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Annuler'),
          ),
          TextButton(
              onPressed: () => {
                Navigator.pop(context, 'OK'),
                widget.onDelete()
              },
              child: const Text('OK')),
        ],
      ),
    );
  }

}