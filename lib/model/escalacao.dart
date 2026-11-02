class Escalacao {
  final int? id;
  final int idPartida;
  final int idJogador;
  final int? idTime; // time (lado) da partida
  final String titular;

  Escalacao({
    this.id,
    required this.idPartida,
    required this.idJogador,
    this.idTime,
    this.titular = "Titular",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_partida': idPartida,
      'id_jogador': idJogador,
      'id_time': idTime,
      'titular': titular,
    };
  }

  factory Escalacao.fromMap(Map<String, dynamic> map) {
    return Escalacao(
      id: map['id'],
      idPartida: map['id_partida'] ?? 0,
      idJogador: map['id_jogador'] ?? 0,
      idTime: map['id_time'],
      titular: map['titular'] ?? "Titular",
    );
  }
}