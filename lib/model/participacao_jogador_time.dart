class ParticipacaoJogadorTime {
  final int? id;
  final int idJogador;
  final int? idEscola;
  final double? valorInscricao;
  final int? idFoto;

  ParticipacaoJogadorTime({
    this.id,
    required this.idJogador,
    this.idEscola,
    this.valorInscricao,
    this.idFoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_jogador': idJogador,
      'id_escola': idEscola,
      'valor_inscricao': valorInscricao,
      'id_foto': idFoto,
    };
  }

  factory ParticipacaoJogadorTime.fromMap(Map<String, dynamic> map) {
    return ParticipacaoJogadorTime(
      id: map['id'],
      idJogador: map['id_jogador'],
      idEscola: map['id_escola'],
      valorInscricao: map['valor_inscricao'],
      idFoto: map['id_foto'],
    );
  }
}