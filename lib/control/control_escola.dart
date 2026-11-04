import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

class ControlEscola {
  static final ControlEscola _instancia = ControlEscola._();

  ControlEscola._();

  factory ControlEscola() => _instancia;

  // RNFR-03.1 — campos obrigatorios da escola
  Future<int> insertDatabase(Escola escola) async {
    if (escola.nome.trim().isEmpty) {
      throw RegraNegocioException("Informe o nome da escola.");
    }
    if (escola.cidade.trim().isEmpty) {
      throw RegraNegocioException("Informe a cidade da escola.");
    }
    if (escola.estado.trim().isEmpty) {
      throw RegraNegocioException("Informe o estado da escola.");
    }
    return await BancoDados().inserir("escola", escola.toMap());
  }

  Future<void> updateDatabase(Escola escola) async {
    Database banco = await BancoDados().db;
    await banco.update("escola", escola.toMap(), where: "id = ?", whereArgs: [escola.id]);
  }

  Future<List<Escola>> queryFind([String? nome]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "escola",
        where: "nome LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("escola");
    }

    return List.generate(resultados.length, (i) {
      return Escola.fromMap(resultados[i]);
    });
  }
}
