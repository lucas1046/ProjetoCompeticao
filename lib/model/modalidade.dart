class Modalidade {
  final int? id;
  final String nome;

  Modalidade({this.id, required this.nome});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  factory Modalidade.fromMap(Map<String, dynamic> map) {
    return Modalidade(
      id: map['id'],
      nome: map['nome'],
    );
  }
}
