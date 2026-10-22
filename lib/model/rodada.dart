class Rodada {
  final int? id;
  final int numero;
  final String data;
  final int idCompeticao;

  Rodada({
    this.id,
    required this.numero,
    required this.data,
    required this.idCompeticao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'data': data,
      'id_competicao': idCompeticao,
    };
  }

  factory Rodada.fromMap(Map<String, dynamic> map) {
    return Rodada(
      id: map['id'],
      numero: map['numero'],
      data: map['data'],
      idCompeticao: map['id_competicao'],
    );
  }
}
