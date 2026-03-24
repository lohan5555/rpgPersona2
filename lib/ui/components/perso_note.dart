import 'package:flutter/material.dart';

import '../../data/models/perso.dart';

class PersoNote extends StatefulWidget {
  final Perso perso;
  final void Function(Perso) onEditPerso;

  const PersoNote({
    super.key,
    required this.perso,
    required this.onEditPerso
  });

  @override
  State<PersoNote> createState() => _PersoNoteState();
}

class _PersoNoteState extends State<PersoNote>{

  final TextEditingController _controllerNote = TextEditingController();

  @override
  void initState() {
    _controllerNote.text = widget.perso.note ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _controllerNote.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _controllerNote,
        maxLines: 6,
        decoration: const InputDecoration(
          labelText: 'Information sur le personnage',
          alignLabelWithHint: true,
          border: InputBorder.none,
        ),
        onChanged: (value) {
          Perso p = widget.perso.copyWith(note: _controllerNote.text);
          widget.onEditPerso(p);
        },
      ),
    );
  }
}
