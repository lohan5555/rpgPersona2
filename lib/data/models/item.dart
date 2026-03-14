class Item{
  final int? id;
  final String name;
  final int quantity;
  final String? desc;
  final int listPosition;
  final int persoId;

  const Item(
      {
        this.id,
        required this.name,
        required this.quantity,
        this.desc,
        required this.listPosition,
        required this.persoId
      }
      );

  Item copyWith({
    String? name,
    int? quantity,
    String? desc,
    int? persoId,
    int? listPosition
  }) {
    return Item(
      id: id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      desc: desc ?? this.desc,
      listPosition: listPosition ?? this.listPosition,
      persoId: persoId ?? this.persoId,
    );
  }


  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'desc' : desc,
      'listPosition' : listPosition,
      'persoId' : persoId,
    };
  }

  @override
  String toString() {
    return 'Partie{id: $id, name: $name, quantity: $quantity, desc: $desc, listPosition: $listPosition, persoId: $persoId}';
  }


}