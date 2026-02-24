class Stat{
  final int? id;
  final String name;
  final int valeur;
  final int persoId;

  const Stat(
      {
        this.id,
        required this.name,
        required this.valeur,
        required this.persoId
      }
      );


  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'valeur': valeur,
      'persoId' : persoId,
    };
  }

  @override
  String toString() {
    return 'Partie{id: $id, name: $name, valeur: $valeur, persoId: $persoId}';
  }


}