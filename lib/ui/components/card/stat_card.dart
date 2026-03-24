import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../data/models/stat.dart';

class StatCard extends StatefulWidget {
  final Stat stat;
  final VoidCallback onDelete;
  final void Function(Stat) onEdit;

  const StatCard({
    super.key,
    required this.stat,
    required this.onDelete,
    required this.onEdit
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>{



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showEditStatDialog,
      child: Card(
        //elevation: 2,
        color: Colors.white,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(16),

        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.stat.name,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.stat.valeur % 1 == 0
                      ? widget.stat.valeur.toInt().toString()
                      : widget.stat.valeur.toString(),
                  style: const TextStyle(fontSize: 35),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //fonction pour éviter les valeurs style 16.59999999999994
  double round1(double v) => double.parse(v.toStringAsFixed(1));

  Future<void> _showEditStatDialog() async {
    final TextEditingController controllerNom = TextEditingController();

    controllerNom.text = widget.stat.name;
    double valeur = widget.stat.valeur;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Pour que setState puisse rebuild le dialog
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: Text("Modifier la caractéristique",overflow: TextOverflow.ellipsis)),
                    IconButton(
                        onPressed: () async {
                          bool deleted = await _showDeleteStatDialog();

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
                        labelText: "Caractéristique",
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(child:
                      Text(
                        valeur.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    DecimalNumberPicker(
                      value: valeur,
                      minValue: -1000,
                      maxValue: 1000,
                      decimalPlaces: 1,
                      onChanged: (newValue) {
                        setStateDialog(() {
                          valeur = round1(newValue);
                        });
                      },
                    ),
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

                          final statModifier = widget.stat.copyWith(
                            name: controllerNom.text.trim(),
                            valeur: valeur,
                          );

                          widget.onEdit(statModifier);

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Stat Modifier')),
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
          }
        );
      },
    );
  }


  Future<bool> _showDeleteStatDialog() async {
    final res = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Center(child: Text('Attention !')),
        content: const Text('Êtes-vous sur de vouloir supprimer cette caractéristique ? Cette action est définitive.'),
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
                      Navigator.pop(context, true),
                      widget.onDelete()
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