import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/pagamento_inscricao.dart';
import 'package:sqflite/sqflite.dart';

class ControlPagamento {
  static final ControlPagamento _instancia = ControlPagamento._();

  ControlPagamento._();

  factory ControlPagamento() => _instancia;

  Future<int> insertDatabase(PagamentoInscricao pagamento) async {
    Database banco = await BancoDados().db;
    return await banco.insert("pagamento_inscricao", pagamento.toMap());
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
