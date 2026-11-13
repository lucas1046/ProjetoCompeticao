import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/rodada.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:projeto_final/util/formatador.dart';
import 'package:sqflite/sqflite.dart';

class ControlRodada {
  static final ControlRodada _instancia = ControlRodada._();

  ControlRodada._();

  factory ControlRodada() => _instancia;

  // RNFR-08.1 e RNFR-08.2
  Future<int> insertDatabase(Rodada rodada) async {
    if (!Validacoes.dataValida(rodada.data)) {
      throw RegraNegocioException(
        "Data da rodada inválida. Use o formato dd/MM/yyyy.",
      );
    }

    if (rodada.numero <= 0) {
      throw RegraNegocioException("O número da rodada deve ser maior que zero.");
    }

    Database banco = await BancoDados().db;

    // RNFR-08.1 — rodada deve estar dentro do período da competição
    List<Map<String, dynamic>> competicao = await banco.query(
      "competicao",
      where: "id = ?",
      whereArgs: [rodada.idCompeticao],
      limit: 1,
    );

    if (competicao.isEmpty) {
      throw RegraNegocioException(
        "Competição não encontrada. Cadastre-a primeiro.",
      );
    }

    String inicio = competicao.first['data_inicio'];
    String fim = competicao.first['data_fim'];

    if (!Validacoes.dentroDoPeriodo(rodada.data, inicio, fim)) {
      throw RegraNegocioException(
        "A data da rodada deve estar entre o início (${Formatador.dataBr(inicio)}) "
        "e o término (${Formatador.dataBr(fim)}) da competição.",
      );
    }

    // RNFR-08.2 — número da rodada único por competição
    List<Map<String, dynamic>> existente = await banco.query(
      "rodada",
      where: "numero = ? AND id_competicao = ?",
      whereArgs: [rodada.numero, rodada.idCompeticao],
    );
    if (existente.isNotEmpty) {
      throw RegraNegocioException(
        "Esta competição já possui uma rodada de número ${rodada.numero}.",
      );
    }

    return await BancoDados().inserir("rodada", rodada.toMap());
  }

  Future<List<Rodada>> queryFind() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados = await banco.query("rodada");

    return List.generate(resultados.length, (i) {
      return Rodada.fromMap(resultados[i]);
    });
  }

  // Consulta detalhada: traz o nome da competição em vez do id
  Future<List<Map<String, dynamic>>> queryFindDetalhado() async {
    Database banco = await BancoDados().db;

    return await banco.rawQuery(
      "SELECT r.id AS id, r.numero AS numero, r.data AS data, "
      "c.nome AS nomeCompeticao "
      "FROM rodada r "
      "JOIN competicao c ON r.id_competicao = c.id "
      "ORDER BY c.nome, r.numero",
    );
  }
}
