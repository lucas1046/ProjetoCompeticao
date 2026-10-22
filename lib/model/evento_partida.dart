class EventoPartida {
  final int? id;
  final int idTipoEvento;
  final int minutoEvento;
  final String descricao;
  final int idEscalacao;

  EventoPartida({
    this.id,
    required this.idTipoEvento,
    required this.minutoEvento,
    required this.descricao,
    required this.idEscalacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_tipo_evento': idTipoEvento,
      'minuto_evento': minutoEvento,
      'descricao': descricao,
      'id_escalacao': idEscalacao,
    };
  }

  factory EventoPartida.fromMap(Map<String, dynamic> map) {
    return EventoPartida(
      id: map['id'],
      idTipoEvento: map['id_tipo_evento'],
      minutoEvento: map['minuto_evento'],
      descricao: map['descricao'],
      idEscalacao: map['id_escalacao'],
    );
  }
}
