class JogadorTime {
  final int? id;
  final int idTime;
  final int idJogador;
  final int? idPosicao;
  final int? numeroCamisa;

  JogadorTime({
    this.id,
    required this.idTime,
    required this.idJogador,
    this.idPosicao,
    this.numeroCamisa,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_time': idTime,
      'id_jogador': idJogador,
      'id_posicao': idPosicao,
      'numero_camisa': numeroCamisa,
    };
  }

  factory JogadorTime.fromMap(Map<String, dynamic> map) {
    return JogadorTime(
      id: map['id'],
      idTime: map['id_time'],
      idJogador: map['id_jogador'],
      idPosicao: map['id_posicao'],
      numeroCamisa: map['numero_camisa'],
    );
  }
}