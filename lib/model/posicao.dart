class Posicao {
  final int? id;
  final String nome;
  final int idModalidade;

  Posicao({
    this.id,
    required this.nome,
    required this.idModalidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'id_modalidade': idModalidade,
    };
  }

  factory Posicao.fromMap(Map<String, dynamic> map) {
    return Posicao(
      id: map['id'],
      nome: map['nome'],
      idModalidade: map['id_modalidade'],
    );
  }
}
