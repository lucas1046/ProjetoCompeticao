class Suspensao {
  final int? id;
  final int idEvento;
  final String motivo;
  final int qtdJogosSuspensao;
  final bool cumprida;

  Suspensao({
    this.id,
    required this.idEvento,
    required this.motivo,
    this.qtdJogosSuspensao = 1,
    this.cumprida = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_evento': idEvento,
      'motivo': motivo,
      'qtd_jogos_suspensao': qtdJogosSuspensao,
      'cumprida': cumprida ? 1 : 0,
    };
  }

  factory Suspensao.fromMap(Map<String, dynamic> map) {
    return Suspensao(
      id: map['id'],
      idEvento: map['id_evento'],
      motivo: map['motivo'],
      qtdJogosSuspensao: map['qtd_jogos_suspensao'],
      cumprida: map['cumprida'] == 1,
    );
  }
}
