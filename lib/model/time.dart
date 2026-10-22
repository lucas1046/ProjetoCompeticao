class Time {
  final int? idTime;
  final int idModalidade;
  final int idEscola;
  final int idCategoria;
  final String nomeTime;

  Time({
    this.idTime,
    required this.idModalidade,
    required this.idEscola,
    required this.idCategoria,
    required this.nomeTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_time': idTime,
      'id_modalidade': idModalidade,
      'id_escola': idEscola,
      'id_categoria': idCategoria,
      'nome_time': nomeTime,
    };
  }

  factory Time.fromMap(Map<String, dynamic> map) {
    return Time(
      idTime: map['id_time'],
      idModalidade: map['id_modalidade'],
      idEscola: map['id_escola'],
      idCategoria: map['id_categoria'],
      nomeTime: map['nome_time'],
    );
  }
}
