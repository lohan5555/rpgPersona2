import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/models/perso.dart';

class PersoGeneral extends StatefulWidget{

  final Perso perso;
  final Function(Perso) onEdit;

  const PersoGeneral({super.key, required this.perso, required this.onEdit});
  @override
  State<PersoGeneral> createState() => _PersoGeneralState();
}


class _PersoGeneralState extends State<PersoGeneral> {

  final TextEditingController _controllerNote = TextEditingController();
  final FocusNode _focusNodeNote = FocusNode();

  @override
  void initState(){
    super.initState();
    _controllerNote.text = widget.perso.note ?? '';
  }

  @override
  void dispose() {
    _controllerNote.dispose();
    _focusNodeNote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _header(),
            const Divider(height: 0,),
            _note(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
        padding: const EdgeInsets.only(top:12, left: 15, right: 15, bottom: 0),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16)
            ),
            child: widget.perso.imgPath == null
                ? Image.asset('assets/placeholder.jpeg', fit: BoxFit.cover)
                : Image.file(File(widget.perso.imgPath!), width: 25, height: 25, fit: BoxFit.cover),
          ),
        )
    );
  }

  Widget _note() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        focusNode: _focusNodeNote,
        onTapOutside: ((event) {
          _focusNodeNote.unfocus();
        }),
        controller: _controllerNote,
        maxLines: 6,
        decoration: const InputDecoration(
          labelText: 'Information sur le personnage',
          alignLabelWithHint: true,
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          Perso p = widget.perso.copyWith(note: _controllerNote.text);
          widget.onEdit(p);
        },
      ),
    );
  }
}