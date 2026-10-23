import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/pagamento_inscricao.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

class ControlPagamento {
  static final ControlPagamento _instancia = ControlPagamento._();

  ControlPagamento._();

  factory ControlPagamento() => _instancia;

  // RNFR-13.1 e RNFR-13.2
  Future<int> insertDatabase(PagamentoInscricao pagamento) async {
    // RNFR-13.2 — valor pago não pode ser zero ou negativo
    if (pagamento.valorPago <= 0) {
      throw RegraNegocioException(
        "O valor pago deve ser maior que zero.",
      );
    }

    if (pagamento.formaPagamento.trim().isEmpty) {
      throw RegraNegocioException("Informe a forma de pagamento.");
    }

    if (!Validacoes.dataValida(pagamento.dataPagamento)) {
      throw RegraNegocioException(
        "Data de pagamento inválida. Use o formato AAAA-MM-DD.",
      );
    }

    Database banco = await BancoDados().db;

    // RNFR-13.1 — pagamento deve estar vinculado a uma inscrição
    List<Map<String, dynamic>> participacao = await banco.query(
      "participacao_jogador_time",
      where: "id = ?",
      whereArgs: [pagamento.idParticipacao],
      limit: 1,
    );
    if (participacao.isEmpty) {
      throw RegraNegocioException(
        "Inscrição não encontrada. O pagamento deve estar vinculado a ela.",
      );
    }

    return await BancoDados().inserir("pagamento_inscricao", pagamento.toMap());
  }

  Future<List<PagamentoInscricao>> queryFind() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados =
        await banco.query("pagamento_inscricao");

    return List.generate(resultados.length, (i) {
      return PagamentoInscricao.fromMap(resultados[i]);
    });
  }
}
