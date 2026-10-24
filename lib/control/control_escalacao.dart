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
    if (escalacao.idPartida <= 0 || escalacao.idParticipacao <= 0) {
      throw RegraNegocioException("Informe a partida e o jogador escalado.");
    }

    if (escalacao.numeroCamisa <= 0) {
      throw RegraNegocioException("Informe o número da camisa.");
    }

    if (escalacao.titular != "Titular" && escalacao.titular != "Suplente") {
      throw RegraNegocioException(
        "A condição deve ser 'Titular' ou 'Suplente'.",
      );
    }

    Database banco = await BancoDados().db;

    // RNFR-10.1 — só escala jogador inscrito no time participante da partida
    List<Map<String, dynamic>> validacao = await banco.rawQuery(
      "SELECT t.id_time_casa, t.id_time_visitante, pj.id_time AS id_time_jogador "
      "FROM partida t "
      "INNER JOIN participacao_jogador_time pj ON pj.id = ? "
      "WHERE t.id = ?",
      [escalacao.idParticipacao, escalacao.idPartida],
    );

    if (validacao.isEmpty) {
      throw RegraNegocioException(
        "Jogador ou partida não encontrados.",
      );
    }

    int timeCasa = validacao.first['id_time_casa'];
    int timeVisitante = validacao.first['id_time_visitante'];
    int timeJogador = validacao.first['id_time_jogador'];

    if (timeJogador != timeCasa && timeJogador != timeVisitante) {
      throw RegraNegocioException(
        "O jogador não está inscrito em nenhum dos times desta partida.",
      );
    }

    // RNFR-10.2 — não escala jogador com suspensão ativa
    List<Map<String, dynamic>> suspenso = await banco.rawQuery(
      "SELECT COUNT(*) AS total FROM suspensao s "
      "INNER JOIN evento_partida ep ON s.id_evento = ep.id "
      "INNER JOIN escalacao e ON ep.id_escalacao = e.id "
      "WHERE e.id_participacao_jogador_time = ? AND s.cumprida = 0",
      [escalacao.idParticipacao],
    );

    int totalSuspensoes = suspenso.first['total'] as int? ?? 0;
    if (totalSuspensoes > 0) {
      throw RegraNegocioException(
        "Este jogador está suspenso e não pode ser escalado.",
      );
    }

    int id = await BancoDados().inserir("escalacao", escalacao.toMap());

    // RNFR-12.2 — o jogador disputou mais uma partida, entao as suspensoes
    // em aberto sao reavaliadas automaticamente
    await ControlSuspensao().atualizarSuspensoes();

    return id;
  }

  // Consulta detalhada: traz o jogador, o time e a partida em vez dos ids
  Future<List<Map<String, dynamic>>> queryFindDetalhado() async {
    Database banco = await BancoDados().db;

    return await banco.rawQuery(
      "SELECT e.id AS id, e.numero_camisa AS numeroCamisa, "
      "e.titular AS titular, j.nome AS nomeJogador, "
      "t.nome_time AS nomeTime, e.id_partida AS idPartida "
      "FROM escalacao e "
      "JOIN participacao_jogador_time pjt "
      "ON e.id_participacao_jogador_time = pjt.id "
      "JOIN jogador j ON pjt.id_jogador = j.id "
      "JOIN time t ON pjt.id_time = t.id_time "
      "ORDER BY e.id_partida, e.numero_camisa",
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
