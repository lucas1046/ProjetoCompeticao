import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/time.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

class ControlTime {
  static final ControlTime _instancia = ControlTime._();

  ControlTime._();

  factory ControlTime() => _instancia;

  // RNFR-04.1 e RNFR-04.2
  Future<int> insertDatabase(Time time) async {
    if (time.nomeTime.trim().isEmpty) {
      throw RegraNegocioException("Informe o nome do time.");
    }

    // RNFR-04.1 — time exige escola, modalidade e categoria
    if (time.idEscola <= 0 || time.idModalidade <= 0 || time.idCategoria <= 0) {
      throw RegraNegocioException(
        "O time deve estar vinculado a uma escola, modalidade e categoria.",
      );
    }

    Database banco = await BancoDados().db;

    // RNFR-04.2 — nome do time único por escola/modalidade/categoria
    List<Map<String, dynamic>> existentes = await banco.query(
      "time",
      where: "nome_time = ? AND id_escola = ? "
          "AND id_modalidade = ? AND id_categoria = ?",
      whereArgs: [
        time.nomeTime,
        time.idEscola,
        time.idModalidade,
        time.idCategoria,
      ],
    );
    if (existentes.isNotEmpty) {
      throw RegraNegocioException(
        "Esta escola já possui um time com este nome nesta modalidade e categoria.",
      );
    }

    return await BancoDados().inserir("time", time.toMap());
  }

  Future<List<Time>> queryFind([String? nome]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "time",
        where: "nome_time LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("time");
    }

    return List.generate(resultados.length, (i) {
      return Time.fromMap(resultados[i]);
    });
  }
}
