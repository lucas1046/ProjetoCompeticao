class TipoEvento {
  final int? id;
  final String descricao;

  TipoEvento({this.id, required this.descricao});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }

  factory TipoEvento.fromMap(Map<String, dynamic> map) {
    return TipoEvento(
      id: map['id'],
      descricao: map['descricao'],
    );
  }
}
