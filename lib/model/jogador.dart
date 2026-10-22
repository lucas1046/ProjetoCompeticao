class Jogador {
  final int? id;
  final String cpf;
  final String nome;
  final String dataNascimento;
  final int idResponsavel;

  Jogador({
    this.id,
    required this.cpf,
    required this.nome,
    required this.dataNascimento,
    required this.idResponsavel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cpf': cpf,
      'nome': nome,
      'data_nascimento': dataNascimento,
      'id_responsavel': idResponsavel,
    };
  }

  factory Jogador.fromMap(Map<String, dynamic> map) {
    return Jogador(
      id: map['id'],
      cpf: map['cpf'],
      nome: map['nome'],
      dataNascimento: map['data_nascimento'],
      idResponsavel: map['id_responsavel'],
    );
  }
}
