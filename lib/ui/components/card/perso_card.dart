import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rpg_persona2/data/models/perso.dart';
import 'package:rpg_persona2/ui/screens/perso_detail_screen.dart';

class PersoCard extends StatelessWidget{
  final Perso perso;
  final VoidCallback onDelete;
  final Function(Perso) onEdit;

  const PersoCard({
    super.key,
    required this.perso,
    required this.onDelete,
    required this.onEdit
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 0),
      shape: ContinuousRectangleBorder(),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PersoDetailPage(perso: perso, onEdit: onEdit, onDelete: onDelete),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16 , left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          backgroundImage: perso.imgPath != null && perso.imgPath!.isNotEmpty
                              ? FileImage(File(perso.imgPath!))
                              : null,
                          child: perso.imgPath == null || perso.imgPath!.isEmpty
                              ? const Icon(Icons.person, size: 30)
                              : null,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                perso.name,
                                style: Theme.of(context).textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 8),
                              if (perso.desc != null && perso.desc!.isNotEmpty) ...[
                                Text(
                                  perso.desc!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ]
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Icon(Icons.drag_handle)
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