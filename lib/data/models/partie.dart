class Partie{
  final int? id;
  final String name;
  final String? desc;
  final String? note;
  final String? imgPath;

  const Partie(
    {
      this.id,
      required this.name,
      this.desc,
      this.note,
      this.imgPath
    }
  );


  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'note': note,
      'imgPath': imgPath
    };
  }

  @override
  String toString() {
    return 'Partie{id: $id, name: $name, desc: $desc, note: $note, '
        'imgPath: $imgPath}';
  }


}