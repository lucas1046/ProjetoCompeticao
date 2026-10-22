class Competicao {
  final int? id;
  final String nome;
  final String cidade;
  final String dataInicio;
  final String dataFim;

  Competicao({
    this.id,
    required this.nome,
    required this.cidade,
    required this.dataInicio,
    required this.dataFim,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cidade': cidade,
      'data_inicio': dataInicio,
      'data_fim': dataFim,
    };
  }

  factory Competicao.fromMap(Map<String, dynamic> map) {
    return Competicao(
      id: map['id'],
      nome: map['nome'],
      cidade: map['cidade'],
      dataInicio: map['data_inicio'],
      dataFim: map['data_fim'],
    );
  }
}
