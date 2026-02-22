class Perso{
  final int? id;
  final String name;
  final String? desc;
  final int partieId;

  const Perso(
      {
        this.id,
        required this.name,
        this.desc,
        required this.partieId
      }
  );


  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'partieId' : partieId,
    };
  }

  @override
  String toString() {
    return 'Partie{id: $id, name: $name, desc: $desc, partieId: $partieId}';
  }


}