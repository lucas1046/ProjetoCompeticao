import 'package:projeto_final/control/banco_dados.dart';
import 'package:sqflite/sqflite.dart';

/// Control responsável pelas consultas de estatísticas e relatórios (RF-14 e RF-15).
class ControlRelatorio {
  static final ControlRelatorio _instancia = ControlRelatorio._();

  ControlRelatorio._();

  factory ControlRelatorio() => _instancia;

  // ---------------------------------------------------------
  // RF-14 - ESTATÍSTICAS DE JOGADOR
  // ---------------------------------------------------------

  // Total de eventos do jogador agrupados por tipo (Gol, Cartão amarelo, etc.)
  Future<List<Map<String, dynamic>>> estatisticasPorTipo(
    int idParticipacao,
  ) async {
    Database banco = await BancoDados().db;
    return await banco.rawQuery(
      "SELECT te.descricao AS tipo, COUNT(*) AS total "
      "FROM evento_partida ep "
      "JOIN escalacao e ON ep.id_escalacao = e.id "
      "JOIN tipo_evento te ON ep.id_tipo_evento = te.id "
      "WHERE e.id_participacao_jogador_time = ? "
      "GROUP BY te.descricao "
      "ORDER BY total DESC",
      [idParticipacao],
    );
  }

  // Quantas vezes o jogador foi craque da partida
  Future<int> totalCraques(int idParticipacao) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultado = await banco.rawQuery(
      "SELECT COUNT(*) AS total FROM partida p "
      "JOIN escalacao e ON p.id_escalacao_craque = e.id "
      "WHERE e.id_participacao_jogador_time = ?",
      [idParticipacao],
    );
    return resultado.first['total'] as int? ?? 0;
  }

  // Total de jogos que o jogador participou (foi escalado)
  Future<int> totalJogos(int idParticipacao) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultado = await banco.rawQuery(
      "SELECT COUNT(*) AS total FROM escalacao "
      "WHERE id_participacao_jogador_time = ?",
      [idParticipacao],
    );
    return resultado.first['total'] as int? ?? 0;
  }

  // ---------------------------------------------------------
  // RF-15 - RELATÓRIOS GERENCIAIS
  // ---------------------------------------------------------

  // Classificação geral dos times (pontos, jogos, vitórias, saldo de gols)
  Future<List<Map<String, dynamic>>> classificacaoGeral() async {
    Database banco = await BancoDados().db;
    return await banco.rawQuery(
      "SELECT t.id_time AS idTime, t.nome_time AS nomeTime, "
      "COUNT(*) AS jogos, "
      "SUM(CASE "
      "  WHEN p.wo = 1 AND p.id_time_wo = t.id_time THEN 1 "  // vitoria por WO
      "  WHEN p.wo = 0 AND ((t.id_time = p.id_time_casa AND p.qtd_gols_time_casa > p.qtd_gols_time_visitante) "
      "       OR (t.id_time = p.id_time_visitante AND p.qtd_gols_time_visitante > p.qtd_gols_time_casa)) THEN 1 "
      "  ELSE 0 END) AS vitorias, "
      "SUM(CASE WHEN p.wo = 0 AND p.qtd_gols_time_casa = p.qtd_gols_time_visitante THEN 1 ELSE 0 END) AS empates, "
      "SUM(CASE "
      "  WHEN p.wo = 1 AND p.id_time_wo <> t.id_time THEN 1 "  // derrota por WO
      "  WHEN p.wo = 0 AND ((t.id_time = p.id_time_casa AND p.qtd_gols_time_casa < p.qtd_gols_time_visitante) "
      "       OR (t.id_time = p.id_time_visitante AND p.qtd_gols_time_visitante < p.qtd_gols_time_casa)) THEN 1 "
      "  ELSE 0 END) AS derrotas, "
      "SUM(CASE "
      "  WHEN p.wo = 1 AND p.id_time_wo = t.id_time THEN 3 "  // gols pro WO (3-0)
      "  WHEN p.wo = 1 AND p.id_time_wo <> t.id_time THEN 0 "
      "  WHEN t.id_time = p.id_time_casa THEN p.qtd_gols_time_casa "
      "  ELSE p.qtd_gols_time_visitante END) AS golsPro, "
      "SUM(CASE "
      "  WHEN p.wo = 1 AND p.id_time_wo = t.id_time THEN 0 "
      "  WHEN p.wo = 1 AND p.id_time_wo <> t.id_time THEN 3 "
      "  WHEN t.id_time = p.id_time_casa THEN p.qtd_gols_time_visitante "
      "  ELSE p.qtd_gols_time_casa END) AS golsContra, "
      "SUM(CASE "
      "  WHEN p.wo = 1 AND p.id_time_wo = t.id_time THEN 3 "  // pontos WO
      "  WHEN p.wo = 1 AND p.id_time_wo <> t.id_time THEN 0 "
      "  WHEN (t.id_time = p.id_time_casa AND p.qtd_gols_time_casa > p.qtd_gols_time_visitante) "
      "       OR (t.id_time = p.id_time_visitante AND p.qtd_gols_time_visitante > p.qtd_gols_time_casa) THEN 3 "
      "  WHEN p.qtd_gols_time_casa = p.qtd_gols_time_visitante THEN 1 "
      "  ELSE 0 END) AS pontos "
      "FROM partida p "
      "JOIN time t ON t.id_time = p.id_time_casa OR t.id_time = p.id_time_visitante "
      "GROUP BY t.id_time, t.nome_time "
      "ORDER BY pontos DESC, golsPro DESC",
    );
  }

  // Situação financeira: valor pago por inscrição de jogador
  Future<List<Map<String, dynamic>>> situacaoFinanceira() async {
    Database banco = await BancoDados().db;
    return await banco.rawQuery(
      "SELECT pjt.id AS idParticipacao, j.nome AS nomeJogador, "
      "e.nome AS nomeEscola, "
      "pjt.valor_inscricao AS valorInscricao, "
      "COALESCE(SUM(pg.valor_pago), 0) AS valorPago "
      "FROM participacao_jogador_time pjt "
      "JOIN jogador j ON pjt.id_jogador = j.id "
      "LEFT JOIN escola e ON pjt.id_escola = e.id "
      "LEFT JOIN pagamento_inscricao pg ON pg.id_participacao_jogador_time = pjt.id "
      "GROUP BY pjt.id, j.nome, e.nome, pjt.valor_inscricao "
      "ORDER BY j.nome",
    );
  }

  // Total arrecadado em inscrições
  Future<double> totalArrecadado() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultado = await banco.rawQuery(
      "SELECT COALESCE(SUM(valor_pago), 0) AS total FROM pagamento_inscricao",
    );
    return (resultado.first['total'] as num?)?.toDouble() ?? 0;
  }

  // Histórico de partidas com os nomes dos times
  Future<List<Map<String, dynamic>>> historicoPartidas() async {
    Database banco = await BancoDados().db;
    return await banco.rawQuery(
      "SELECT p.id AS idPartida, p.qtd_gols_time_casa AS golsCasa, "
      "p.qtd_gols_time_visitante AS golsVisitante, "
      "p.wo AS wo, tc.nome_time AS timeCasa, tv.nome_time AS timeVisitante, "
      "r.numero AS numeroRodada, c.nome AS nomeCompeticao "
      "FROM partida p "
      "JOIN time tc ON p.id_time_casa = tc.id_time "
      "JOIN time tv ON p.id_time_visitante = tv.id_time "
      "JOIN rodada r ON p.id_rodada = r.id "
      "JOIN competicao c ON r.id_competicao = c.id "
      "ORDER BY p.id",
    );
  }

  // Chave da competição: times participantes com escola e jogadores
  Future<Map<String, dynamic>> chaveCompeticao(int idCompeticao) async {
    Database banco = await BancoDados().db;

    final comp = await banco.query(
      "competicao",
      where: "id = ?",
      whereArgs: [idCompeticao],
      limit: 1,
    );
    if (comp.isEmpty) return {};

    // times que aparecem em partidas da competição
    final timesRows = await banco.rawQuery(
      "SELECT DISTINCT t.id_time AS idTime, t.nome_time AS nomeTime, "
      "e.nome AS nomeEscola, e.cidade AS cidadeEscola "
      "FROM time t "
      "JOIN escola e ON t.id_escola = e.id "
      "JOIN partida p ON (p.id_time_casa = t.id_time OR p.id_time_visitante = t.id_time) "
      "JOIN rodada r ON p.id_rodada = r.id "
      "WHERE r.id_competicao = ? "
      "ORDER BY t.nome_time",
      [idCompeticao],
    );

    List<Map<String, dynamic>> times = [];
    for (final t in timesRows) {
      final idTime = t['idTime'] as int;
      final jogs = await banco.rawQuery(
        "SELECT j.nome AS nome, pj.numero_camisa AS camisa "
        "FROM participacao_jogador_time pj "
        "JOIN jogador j ON pj.id_jogador = j.id "
        "WHERE pj.id_time = ? "
        "ORDER BY j.nome",
        [idTime],
      );
      times.add({
        'idTime': idTime,
        'nomeTime': t['nomeTime'],
        'nomeEscola': t['nomeEscola'],
        'cidadeEscola': t['cidadeEscola'],
        'jogadores': jogs,
      });
    }

    return {
      'competicao': comp.first,
      'times': times,
    };
  }

  // Lista de competições para selecionar
  Future<List<Map<String, dynamic>>> listarCompeticoes() async {
    Database banco = await BancoDados().db;
    return await banco.query("competicao", orderBy: "nome");
  }
  // Jogadores suspensos (suspensões não cumpridas)
  Future<List<Map<String, dynamic>>> jogadoresSuspensos() async {
    Database banco = await BancoDados().db;
    return await banco.rawQuery(
      "SELECT s.id AS idSuspensao, s.motivo AS motivo, "
      "s.qtd_jogos_suspensao AS qtdJogos, "
      "te.descricao AS tipoEvento, ep.minuto_evento AS minuto, "
      "j.nome AS nomeJogador, t.nome_time AS nomeTime "
      "FROM suspensao s "
      "JOIN evento_partida ep ON s.id_evento = ep.id "
      "JOIN tipo_evento te ON ep.id_tipo_evento = te.id "
      "JOIN escalacao e ON ep.id_escalacao = e.id "
      "JOIN participacao_jogador_time pjt ON e.id_participacao_jogador_time = pjt.id "
      "JOIN jogador j ON pjt.id_jogador = j.id "
      "JOIN time t ON pjt.id_time = t.id_time "
      "WHERE s.cumprida = 0 "
      "ORDER BY j.nome",
    );
  }
}
