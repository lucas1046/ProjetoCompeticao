class Partida {
  final int? id;
  final int idRodada;
  final int idTimeCasa;
  final int idTimeVisitante;
  final int qtdGolsTimeCasa;
  final int qtdGolsTimeVisitante;
  final bool wo;
  final int? idTimeWo;
  final int? idEscalacaoCraque;
  final String? horario;

  Partida({
    this.id,
    required this.idRodada,
    required this.idTimeCasa,
    required this.idTimeVisitante,
    this.qtdGolsTimeCasa = 0,
    this.qtdGolsTimeVisitante = 0,
    this.wo = false,
    this.idTimeWo,
    this.idEscalacaoCraque,
    this.horario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_rodada': idRodada,
      'id_time_casa': idTimeCasa,
      'id_time_visitante': idTimeVisitante,
      'qtd_gols_time_casa': qtdGolsTimeCasa,
      'qtd_gols_time_visitante': qtdGolsTimeVisitante,
      'wo': wo ? 1 : 0,
      'id_time_wo': idTimeWo,
      'id_escalacao_craque': idEscalacaoCraque,
      'horario': horario,
    };
  }

  factory Partida.fromMap(Map<String, dynamic> map) {
    return Partida(
      id: map['id'],
      idRodada: map['id_rodada'],
      idTimeCasa: map['id_time_casa'],
      idTimeVisitante: map['id_time_visitante'],
      qtdGolsTimeCasa: map['qtd_gols_time_casa'],
      qtdGolsTimeVisitante: map['qtd_gols_time_visitante'],
      wo: map['wo'] == 1,
      idTimeWo: map['id_time_wo'],
      idEscalacaoCraque: map['id_escalacao_craque'],
      horario: map['horario'],
    );
  }
}
