class ParticipacaoJogadorTime {
  final int? id;
  final int idJogador;
  final int idTime;
  final int? numeroCamisa;
  final double? valorInscricao;
  final int? idFoto;

  ParticipacaoJogadorTime({
    this.id,
    required this.idJogador,
    required this.idTime,
    this.numeroCamisa,
    this.valorInscricao,
    this.idFoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_jogador': idJogador,
      'id_time': idTime,
      'numero_camisa': numeroCamisa,
      'valor_inscricao': valorInscricao,
      'id_foto': idFoto,
    };
  }

  factory ParticipacaoJogadorTime.fromMap(Map<String, dynamic> map) {
    return ParticipacaoJogadorTime(
      id: map['id'],
      idJogador: map['id_jogador'],
      idTime: map['id_time'],
      numeroCamisa: map['numero_camisa'],
      valorInscricao: map['valor_inscricao'],
      idFoto: map['id_foto'],
    );
  }
}
