class Stat{
  final int? id;
  final String name;
  final double valeur;
  final int listPosition;
  final int persoId;

  const Stat(
      {
        this.id,
        required this.name,
        required this.valeur,
        required this.listPosition,
        required this.persoId
      }
      );

  Stat copyWith({
    String? name,
    double? valeur,
    int ? listPosition,
    int? persoId
  }) {
    return Stat(
      id: id,
      name: name ?? this.name,
      valeur: valeur ?? this.valeur,
      listPosition: listPosition ?? this.listPosition,
      persoId: persoId ?? this.persoId,
    );
  }


  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'valeur': valeur,
      'listPosition' : listPosition,
      'persoId' : persoId,
    };
  }

  @override
  String toString() {
    return 'Partie{id: $id, name: $name, valeur: $valeur, listPosition: $listPosition persoId: $persoId}';
  }


}