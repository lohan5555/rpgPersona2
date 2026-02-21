import 'package:flutter/material.dart';
import 'package:rpg_persona2/data/models/partie.dart';

class PartieDetailPage extends StatelessWidget {
  final Partie partie;

  const PartieDetailPage({super.key, required this.partie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(partie.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date de début : ${partie.dateDebut.toLocal()}'),
          Text('Date de fin : ${partie.dateFin.toLocal()}'),
        ],
      ),
    );
  }
}