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
            onTap: () {
              setState(() {
                focusCard = !focusCard;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 10, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(!focusCard) ...[
                          Text(
                            widget.item.name,
                            style: Theme.of(context).textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                        if(focusCard)...[
                          Text(
                            widget.item.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ],
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
                      IconButton(onPressed: _showEditItemDialog, icon: Icon(Icons.edit, size: 20))
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

  Future<void> _showEditItemDialog() async {
    final TextEditingController controllerNom = TextEditingController();
    final TextEditingController controllerDesc = TextEditingController();

    controllerNom.text = widget.item.name;
    if(widget.item.desc != null) {controllerDesc.text = widget.item.desc!;}

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Modifier l'objet"),
                IconButton(
                  onPressed: () async {
                    bool deleted = await _showDeleteItemDialog();

                    if (deleted) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.delete)
                )
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controllerNom,
                  decoration: InputDecoration(
                    labelText: "Nom de l'objet",
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controllerDesc,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description de l'objet",
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controllerNom.text.trim().isEmpty) return;

                      final itemModifier = widget.item.copyWith(
                        name: controllerNom.text.trim(),
                        desc: controllerDesc.text.trim()
                      );

                      widget.onEdit(itemModifier);

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Objet Modifier')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(233, 193, 108, 1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Modifier'),
                  )
                )
              ],
            ),
          ],
        );
      },
    );
  }


  Future<bool> _showDeleteItemDialog() async {
    final res = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Center(child: Text('Attention !')),
        content: const Text("Êtes-vous sur de vouloir supprimer cet objet de l'inventaire ? Cette action est définitive."),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
                )
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(233, 193, 108, 1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => {
                    widget.onDelete(),
                    Navigator.pop(context, true)
                  },
                  child: const Text('OK')
                )
              ),
            ],
          )
        ]
      ),
    );
    return res ?? false;
  }

}