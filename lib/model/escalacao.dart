class Escalacao {
  final int? id;
  final int idPartida;
  final String titular;
  final int numeroCamisa;
  final int idPosicao;
  final int idParticipacao;

  Escalacao({
    this.id,
    required this.idPartida,
    required this.titular,
    required this.numeroCamisa,
    required this.idPosicao,
    required this.idParticipacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_partida': idPartida,
      'titular': titular,
      'numero_camisa': numeroCamisa,
      'id_posicao': idPosicao,
      'id_participacao_jogador_time': idParticipacao,
    };
  }

  factory Escalacao.fromMap(Map<String, dynamic> map) {
    return Escalacao(
      id: map['id'],
      idPartida: map['id_partida'],
      titular: map['titular'],
      numeroCamisa: map['numero_camisa'],
      idPosicao: map['id_posicao'],
      idParticipacao: map['id_participacao_jogador_time'],
    );
  }
}
