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
    return Stack(
      children: [
        Card(
          color: Colors.transparent,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 0),
          shape: ContinuousRectangleBorder(),
          child: InkWell(
            onTap: () {}, // obligatoire pour que le InkWell réagisse
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 10, bottom: 0),
              child: Column(
                children: [
                  Text(
                    widget.stat.name,
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      IconButton(
                          icon: Image.asset(
                            "assets/button/moinsEntier.png",
                            width: 20,
                            height: 20,
                          ),
                          onPressed: () async {
                            final statEdit = widget.stat.copyWith(
                              valeur: round1(widget.stat.valeur-1),
                            );
                            widget.onEdit(statEdit);
                          }
                      ),
                      IconButton(
                          icon: Image.asset(
                            "assets/button/moinsDecimal.png",
                            width: 20,
                            height: 20,
                          ),
                          onPressed: () async {
                            final statEdit = widget.stat.copyWith(
                              valeur: round1(widget.stat.valeur-0.1),
                            );
                            widget.onEdit(statEdit);
                          }
                      ),
                      widget.stat.valeur-widget.stat.valeur.toInt()==0
                          ?Text(
                        widget.stat.valeur.toInt().toString(),
                        style: TextStyle(fontSize: 30),
                      )
                          :Text(
                        widget.stat.valeur.toString(),
                        style: TextStyle(fontSize: 30),
                      ),
                      IconButton(
                          icon: Image.asset(
                            "assets/button/plusDecimal.png",
                            width: 20,
                            height: 20,
                          ),
                          onPressed: () async {
                            final statEdit = widget.stat.copyWith(
                              valeur: round1(widget.stat.valeur+0.1),
                            );
                            widget.onEdit(statEdit);
                          }
                      ),
                      IconButton(
                          icon: Image.asset(
                            "assets/button/plusEntier.png",
                            width: 20,
                            height: 20,
                          ),
                          onPressed: () async {
                            final statEdit = widget.stat.copyWith(
                              valeur: round1(widget.stat.valeur+1),
                            );
                            widget.onEdit(statEdit);
                          }
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Divider(height: 0)
                ],
              ),
            ),
          ),
        ),
        Positioned(
            right: 5,
            top: 10,
            child: IconButton(onPressed: _showEditStatDialog, icon: Icon(Icons.edit))
        )
      ],
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