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
            _note(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Stack(
      children: [
        Center(
          child: Container(
            width: 1000,
            height: 125,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15))
            ),
          ),
        ),
        Center(
          child: Padding(
              padding: const EdgeInsets.only(top:15, left: 15, right: 15, bottom: 20),
              child: CircleAvatar(
                radius: 102,
                backgroundColor: Colors.black,//Color.fromRGBO(251, 196, 58, 1.0),
                child: CircleAvatar(
                    radius: 100,
                    backgroundImage: widget.perso.imgPath == null
                        ? AssetImage("assets/placeholder/userPlaceholder.webp")
                        : FileImage(File(widget.perso.imgPath!))
                ),
              )
          ),
        )
      ],
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