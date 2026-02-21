import 'package:flutter/material.dart';

import '../data/models/partie.dart';
import 'partie_detail_page.dart';

class PartieCard extends StatelessWidget{
  final Partie partie;

  const PartieCard({
    super.key,
    required this.partie
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PartieDetailPage(partie: partie),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                partie.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Début : ${partie.dateDebut.toLocal()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'Fin : ${partie.dateFin.toLocal()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

}