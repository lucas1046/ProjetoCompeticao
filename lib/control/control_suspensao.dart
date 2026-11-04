import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/suspensao.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

class ControlSuspensao {
  static final ControlSuspensao _instancia = ControlSuspensao._();

  ControlSuspensao._();

  factory ControlSuspensao() => _instancia;

  // RNFR-12.1 — toda suspensão deve ter origem em um evento de partida
  Future<int> insertDatabase(Suspensao suspensao) async {
    if (suspensao.idEvento <= 0) {
      throw RegraNegocioException(
        "A suspensão deve ser originada por um evento de partida.",
      );
    }

    if (suspensao.motivo.trim().isEmpty) {
      throw RegraNegocioException("Informe o motivo da suspensão.");
    }

    if (suspensao.qtdJogosSuspensao <= 0) {
      throw RegraNegocioException(
        "A quantidade de jogos de suspensão deve ser maior que zero.",
      );
    }

    Database banco = await BancoDados().db;

    List<Map<String, dynamic>> evento = await banco.query(
      "evento_partida",
      where: "id = ?",
      whereArgs: [suspensao.idEvento],
      limit: 1,
    );
    if (evento.isEmpty) {
      throw RegraNegocioException(
        "Evento de partida não encontrado. A suspensão precisa de uma origem.",
      );
    }

    return await BancoDados().inserir("suspensao", suspensao.toMap());
  }

  Future<void> updateDatabase(Suspensao suspensao) async {
    Database banco = await BancoDados().db;
    await banco.update("suspensao", suspensao.toMap(), where: "id = ?", whereArgs: [suspensao.id]);
  }

  // Consulta detalhada: traz o jogador e o tipo de evento em vez dos ids
  Future<List<Map<String, dynamic>>> queryFindDetalhado() async {
    Database banco = await BancoDados().db;

    return await banco.rawQuery(
      "SELECT s.id AS id, s.motivo AS motivo, "
      "s.qtd_jogos_suspensao AS qtdJogos, s.cumprida AS cumprida, "
      "j.nome AS nomeJogador, te.descricao AS tipoEvento, "
      "ep.minuto_evento AS minuto "
      "FROM suspensao s "
      "JOIN evento_partida ep ON s.id_evento = ep.id "
      "JOIN tipo_evento te ON ep.id_tipo_evento = te.id "
      "JOIN escalacao e ON ep.id_escalacao = e.id "
      "JOIN jogador j ON e.id_jogador = j.id "
      "ORDER BY j.nome",
    );
  }

  // RNFR-12.2 — atualiza o status (cumprida/nao cumprida) de todas as
  // suspensoes com base nas partidas disputadas pelo jogador depois da
  // infração. Retorna quantas suspensoes foram dadas como cumpridas.
  Future<int> atualizarSuspensoes() async {
    Database banco = await BancoDados().db;

    List<Map<String, dynamic>> pendentes = await banco.rawQuery(
      "SELECT s.id AS id_suspensao, "
      "s.qtd_jogos_suspensao AS qtd_jogos, "
      "r.data AS data_infracao, "
      "e.id_jogador AS id_jogador "
      "FROM suspensao s "
      "JOIN evento_partida ep ON s.id_evento = ep.id "
      "JOIN escalacao e ON ep.id_escalacao = e.id "
      "JOIN partida p ON e.id_partida = p.id "
      "JOIN rodada r ON p.id_rodada = r.id "
      "WHERE s.cumprida = 0",
    );

    int atualizadas = 0;

    for (Map<String, dynamic> suspensao in pendentes) {
      int idSuspensao = suspensao['id_suspensao'] as int;
      int qtdJogos = suspensao['qtd_jogos'] as int;
      String dataInfracao = suspensao['data_infracao'];
      int idJogador = suspensao['id_jogador'] as int;

      // Partidas disputadas pelo jogador depois da data da infração
      List<Map<String, dynamic>> jogos = await banco.rawQuery(
        "SELECT COUNT(DISTINCT p2.id) AS total "
        "FROM partida p2 "
        "JOIN rodada r2 ON p2.id_rodada = r2.id "
        "JOIN escalacao e2 ON e2.id_partida = p2.id "
        "WHERE e2.id_jogador = ? AND r2.data > ?",
        [idJogador, dataInfracao],
      );

      int disputadas = jogos.first['total'] as int? ?? 0;

      if (disputadas >= qtdJogos) {
        await banco.update(
          "suspensao",
          {"cumprida": 1},
          where: "id = ?",
          whereArgs: [idSuspensao],
        );
        atualizadas++;
      }
    }

    return atualizadas;
  }

  Future<List<Suspensao>> queryFind([String? motivo]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (motivo != null && motivo.isNotEmpty) {
      resultados = await banco.query(
        "suspensao",
        where: "motivo LIKE ?",
        whereArgs: ["%$motivo%"],
      );
    } else {
      resultados = await banco.query("suspensao");
    }

    return List.generate(resultados.length, (i) {
      return Suspensao.fromMap(resultados[i]);
    });
  }
}
