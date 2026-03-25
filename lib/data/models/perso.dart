class Perso{
  final int? id;
  final String name;
  final String? desc;
  final String? note;
  final String? imgPath;
  final int listPosition;
  final int alive;
  final int partieId;

  const Perso(
      {
        this.id,
        required this.name,
        this.desc,
        this.note,
        this.imgPath,
        required this.listPosition,
        required this.alive,
        required this.partieId
      }
  );


  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'note': note,
      'imgPath' : imgPath,
      'listPosition' : listPosition,
      'alive' : alive,
      'partieId' : partieId,
    };
  }

  @override
  String toString() {
    return 'Partie{id: $id, name: $name, desc: $desc, note: $note, imgPath: $imgPath, listPosition: $listPosition, alive: $alive, partieId: $partieId}';
  }

  Perso copyWith({
    String? name,
    String? desc,
    String? note,
    String? imgPath,
    int? listPosition,
    int? alive,
    int? partieId
  }) {
    return Perso(
        id: id,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        note: note ?? this.note,
        imgPath: imgPath ?? this.imgPath,
        alive: alive ?? this.alive,
        listPosition: listPosition ?? this.listPosition,
        partieId: partieId ?? this.partieId
    );
  }


}