import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/control/control_suspensao.dart';
import 'package:projeto_final/model/escalacao.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

class ControlEscalacao {
  static final ControlEscalacao _instancia = ControlEscalacao._();

  ControlEscalacao._();

  factory ControlEscalacao() => _instancia;

  // RNFR-10.1 e RNFR-10.2
  Future<int> insertDatabase(Escalacao escalacao) async {
    if (escalacao.idPartida <= 0 || escalacao.idJogador <= 0) {
      throw RegraNegocioException("Informe a partida e o jogador escalado.");
    }

    Database banco = await BancoDados().db;

    // evita escalar o mesmo jogador duas vezes na mesma partida
    List<Map<String, dynamic>> existente = await banco.query(
      "escalacao",
      where: "id_partida = ? AND id_jogador = ?",
      whereArgs: [escalacao.idPartida, escalacao.idJogador],
    );
    if (existente.isNotEmpty) {
      throw RegraNegocioException("Este jogador já está escalado nesta partida.");
    }

    int id = await BancoDados().inserir("escalacao", escalacao.toMap());

    await ControlSuspensao().atualizarSuspensoes();

    return id;
  }

  Future<List<Map<String, dynamic>>> queryFindDetalhado() async {
    Database banco = await BancoDados().db;

    return await banco.rawQuery(
      "SELECT e.id AS id, j.nome AS nomeJogador, "
      "t.nome_time AS nomeTime, e.id_partida AS idPartida, e.id_jogador AS idJogador "
      "FROM escalacao e "
      "JOIN jogador j ON e.id_jogador = j.id "
      "LEFT JOIN time t ON e.id_time = t.id_time "
      "ORDER BY e.id_partida",
    );
  }

  Future<List<Escalacao>> queryFind() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados = await banco.query("escalacao");

    return List.generate(resultados.length, (i) {
      return Escalacao.fromMap(resultados[i]);
    });
  }
}
