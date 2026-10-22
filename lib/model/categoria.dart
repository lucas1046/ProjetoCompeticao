class Categoria {
  final int? id;
  final String nome;
  final int idadeMin;
  final int idadeMax;

  Categoria({
    this.id,
    required this.nome,
    required this.idadeMin,
    required this.idadeMax,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idade_min': idadeMin,
      'idade_max': idadeMax,
    };
  }

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'],
      nome: map['nome'],
      idadeMin: map['idade_min'],
      idadeMax: map['idade_max'],
    );
  }
}
