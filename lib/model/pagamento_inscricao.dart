class PagamentoInscricao {
  final int? id;
  final int idParticipacao;
  final double valorPago;
  final String dataPagamento;
  final String formaPagamento;
  final String observacoes;

  PagamentoInscricao({
    this.id,
    required this.idParticipacao,
    required this.valorPago,
    required this.dataPagamento,
    required this.formaPagamento,
    required this.observacoes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_participacao_jogador_time': idParticipacao,
      'valor_pago': valorPago,
      'data_pagamento': dataPagamento,
      'forma_pagamento': formaPagamento,
      'observacoes': observacoes,
    };
  }

  factory PagamentoInscricao.fromMap(Map<String, dynamic> map) {
    return PagamentoInscricao(
      id: map['id'],
      idParticipacao: map['id_participacao_jogador_time'],
      valorPago: map['valor_pago'],
      dataPagamento: map['data_pagamento'],
      formaPagamento: map['forma_pagamento'],
      observacoes: map['observacoes'],
    );
  }
}
