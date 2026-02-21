class Partie{
  final int? id;
  final String name;
  final String? desc;
  final DateTime dateDebut;
  final DateTime dateFin;

  const Partie(
    {
      this.id,
      required this.name,
      this.desc,
      required this.dateDebut,
      required this.dateFin
    }
  );


  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String()
    };
  }

  @override
  String toString() {
    return 'Partie{id: $id, name: $name, desc: $desc, dateDebut: $dateDebut, '
        'dateFin: $dateFin}';
  }


}