import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:projeto_final/util/formatador.dart';
import 'package:sqflite/sqflite.dart';

class ControlCompeticao {
  static final ControlCompeticao _instancia = ControlCompeticao._();

  ControlCompeticao._();

  factory ControlCompeticao() => _instancia;

  // RNFR-01.1 e RNFR-01.2
  Future<int> insertDatabase(Competicao competicao) async {
    if (!Validacoes.dataValida(competicao.dataInicio)) {
      throw RegraNegocioException(
        "Data de início inválida. Use o formato dd/MM/yyyy.",
      );
    }

    if (!Validacoes.dataValida(competicao.dataFim)) {
      throw RegraNegocioException(
        "Data de término inválida. Use o formato dd/MM/yyyy.",
      );
    }

    // RNFR-01.1 — término não pode ser anterior ao início
    if (Formatador.paraDateTime(competicao.dataFim)!
        .isBefore(Formatador.paraDateTime(competicao.dataInicio)!)) {
      throw RegraNegocioException(
        "A data de término deve ser maior ou igual à data de início.",
      );
    }

    Database banco = await BancoDados().db;

    // RNFR-01.2 — nome da competição deve ser único
    List<Map<String, dynamic>> existentes = await banco.query(
      "competicao",
      where: "nome = ?",
      whereArgs: [competicao.nome],
    );
    if (existentes.isNotEmpty) {
      throw RegraNegocioException(
        "Já existe uma competição cadastrada com este nome.",
      );
    }

    return await BancoDados().inserir("competicao", competicao.toMap());
  }

  Future<void> updateDatabase(Competicao competicao) async {
    Database banco = await BancoDados().db;
    await banco.update("competicao", competicao.toMap(), where: "id = ?", whereArgs: [competicao.id]);
  }

  Future<List<Competicao>> queryFind([String? nome]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "competicao",
        where: "nome LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("competicao");
    }

    return List.generate(resultados.length, (i) {
      return Competicao.fromMap(resultados[i]);
    });
  }
}
