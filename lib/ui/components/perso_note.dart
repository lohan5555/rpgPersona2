import 'dart:async';

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
  Timer? _debounce;

  @override
  void initState() {
    _controllerNote.text = widget.perso.note ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _controllerNote.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _autoSave(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final p = widget.perso.copyWith(note: value);
      widget.onEditPerso(p);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _controllerNote,
        maxLines: null,
        minLines: null,
        expands: true,
        decoration: const InputDecoration(
          labelText: 'Information sur le personnage',
          alignLabelWithHint: true,
          border: InputBorder.none,
        ),
        onChanged: _autoSave,
      ),
    );
  }
}
