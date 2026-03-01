class Partie{
  final int? id;
  final String name;
  final String? desc;
  final String? note;
  final String? imgPath;
  final String emoji;

  const Partie(
    {
      this.id,
      required this.name,
      this.desc,
      this.note,
      this.imgPath,
      required this.emoji
    }
  );

  Partie copyWith({
    String? name,
    String? desc,
    String? note,
    String? imgPath,
    String? emoji
  }) {
    return Partie(
      id: id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      note: note ?? this.note,
      imgPath: imgPath ?? this.imgPath, 
      emoji: emoji ?? this.emoji
    );
  }


  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'note': note,
      'imgPath': imgPath,
      'emoji': emoji
    };
  }

  @override
  String toString() {
    return 'Partie{id: $id, name: $name, desc: $desc, note: $note, '
        'imgPath: $imgPath}, emoji $emoji';
  }


}