import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../data/models/perso.dart';
import '../../data/models/stat.dart';
import 'card/stat_card.dart';

class PersoGeneral extends StatefulWidget{
  final List<Stat> stat;

  final Perso perso;
  final Function(Perso) onEditPerso;
  final Function(Stat) onEditStat;
  final Function(int) onDeleteStat;

  const PersoGeneral({
    super.key,
    required this.perso,
    required this.stat,
    required this.onEditPerso,
    required this.onEditStat,
    required this.onDeleteStat,
  });

  @override
  State<PersoGeneral> createState() => _PersoGeneralState();
}


class _PersoGeneralState extends State<PersoGeneral> {

  final TextEditingController _controllerNote = TextEditingController();
  final FocusNode _focusNodeNote = FocusNode();

  late List<Stat> _stats;
  late bool _alive;

  @override
  void initState(){
    super.initState();
    _controllerNote.text = widget.perso.note ?? '';
    _stats = widget.stat;
    widget.perso.alive == 1 ? _alive = true : _alive = false;
  }

  @override
  void didUpdateWidget(covariant PersoGeneral oldWidget) {
    super.didUpdateWidget(oldWidget);
    _stats = widget.stat;
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
            _statsList()
          ],
        ),
      ),
      floatingActionButton: Column(
        children: [
          Text(_alive ? "Vivant" : "Mort"),
          Switch(
            value: _alive,
            activeTrackColor: Color.fromRGBO(233, 193, 108, 1),
            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
              return Colors.grey[700];
            }),
            onChanged: (bool value) {
              setState(() {
                _alive = value;
              });
              Perso p = widget.perso.copyWith(alive: value ? 1 : 0);
              widget.onEditPerso(p);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
                backgroundColor: Colors.black,
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

  Widget _statsList(){
    if (_stats.isEmpty) {
      return const Expanded(
        child:
          Center(child: Text('Aucune statistique')),
      );
    }
    return Expanded(
        child: ReorderableGridView.builder(
          dragWidgetBuilder: (index, child) {
            return Material(
              elevation: 1,
              shadowColor: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(7),
              color: Colors.transparent,
              child: child,
            );
          },
          padding: const EdgeInsets.all(10),
          itemCount: _stats.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              final item = _stats.removeAt(oldIndex);
              _stats.insert(newIndex, item);
            });
            for (int i = 0; i < _stats.length; i++) {
              widget.onEditStat(_stats[i].copyWith(listPosition: i));
            }
          },
          itemBuilder: (context, index) {
            final stat = _stats[index];
            return StatCard(
              key: ValueKey(stat.id),
              stat: stat,
              onDelete: () => widget.onDeleteStat(stat.id!),
              onEdit: widget.onEditStat,
            );
          },
        )
    ) ;
  }
}