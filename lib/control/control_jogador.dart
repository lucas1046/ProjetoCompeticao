import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/control/control_auditoria.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

class ControlJogador {
  static final ControlJogador _instancia = ControlJogador._();

  ControlJogador._();

  factory ControlJogador() => _instancia;

  // RNFR-05.1 e RNFR-05.3
  Future<int> insertDatabase(Jogador jogador) async {
    if (jogador.nome.trim().isEmpty) {
      throw RegraNegocioException("Informe o nome do jogador.");
    }

    // RNFR-05.1 — valida CPF
    if (!Validacoes.cpfValido(jogador.cpf)) {
      throw RegraNegocioException("CPF do jogador inválido.");
    }

    // RNFR-05.3 — jogador deve estar vinculado a um responsável
    if (jogador.idResponsavel <= 0) {
      throw RegraNegocioException(
        "O jogador deve estar vinculado a um responsável legal.",
      );
    }

    Database banco = await BancoDados().db;

    List<Map<String, dynamic>> responsavel = await banco.query(
      "responsavel",
      where: "id = ?",
      whereArgs: [jogador.idResponsavel],
      limit: 1,
    );
    if (responsavel.isEmpty) {
      throw RegraNegocioException(
        "Responsável não encontrado. Cadastre-o primeiro.",
      );
    }

    int id = await BancoDados().inserir("jogador", jogador.toMap());
    await ControlAuditoria().registrar(
      acao: "INSERT",
      tabela: "jogador",
      idRegistro: id,
      detalhes: "Jogador ${jogador.nome} cadastrado",
    );
    return id;
  }

  Future<List<Jogador>> queryFind([String? nome]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "jogador",
        where: "nome LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("jogador");
    }

    return List.generate(resultados.length, (i) {
      return Jogador.fromMap(resultados[i]);
    });
  }

  Future<List<Jogador>> queryByEscola(int idEscola) async {
    Database banco = await BancoDados().db;
    final res = await banco.rawQuery(
      "SELECT DISTINCT j.* FROM jogador j "
      "JOIN participacao_jogador_time p ON p.id_jogador = j.id "
      "WHERE p.id_escola = ?",
      [idEscola],
    );
    return res.map((m) => Jogador.fromMap(m)).toList();
  }

  // Consulta detalhada: traz o nome do responsável em vez do id
  Future<List<Map<String, dynamic>>> queryFindDetalhado([String? nome]) async {
    Database banco = await BancoDados().db;

    String sql = "SELECT j.id AS id, j.cpf AS cpf, j.nome AS nome, "
        "j.data_nascimento AS dataNascimento, j.id_foto AS idFoto, "
        "r.nome AS nomeResponsavel, r.telefone AS telefoneResponsavel "
        "FROM jogador j "
        "LEFT JOIN responsavel r ON j.id_responsavel = r.id";

    List<dynamic> args = [];

    if (nome != null && nome.isNotEmpty) {
      sql += " WHERE j.nome LIKE ?";
      args.add("%$nome%");
    }

    sql += " ORDER BY j.nome";

    return await banco.rawQuery(sql, args);
  }

  // Histórico completo do jogador: participações, partidas, eventos e suspensões
  Future<Map<String, dynamic>> historicoJogador(int idJogador) async {
    Database banco = await BancoDados().db;

    // Dados do jogador
    List<Map<String, dynamic>> jogador = await banco.rawQuery(
      "SELECT j.id, j.cpf, j.nome, j.data_nascimento, r.nome AS nomeResponsavel "
      "FROM jogador j LEFT JOIN responsavel r ON j.id_responsavel = r.id "
      "WHERE j.id = ?",
      [idJogador],
    );

    // Participações (times)
    List<Map<String, dynamic>> participacoes = await banco.rawQuery(
      "SELECT p.id, p.valor_inscricao, e.nome AS nomeEscola "
      "FROM participacao_jogador_time p "
      "LEFT JOIN escola e ON p.id_escola = e.id "
      "WHERE p.id_jogador = ?",
      [idJogador],
    );

    List<int> idsPart = participacoes.map((p) => p['id'] as int).toList();

    // Pagamentos por participação
    Map<int, List<Map<String, dynamic>>> pagamentos = {};
    if (idsPart.isNotEmpty) {
      String placeholders = idsPart.map((_) => '?').join(',');
      List<Map<String, dynamic>> pgs = await banco.rawQuery(
        "SELECT id_participacao_jogador_time, valor_pago, data_pagamento, "
        "forma_pagamento FROM pagamento_inscricao "
        "WHERE id_participacao_jogador_time IN ($placeholders)",
        idsPart,
      );
      for (var pg in pgs) {
        int id = pg['id_participacao_jogador_time'] as int;
        pagamentos.putIfAbsent(id, () => []).add(pg);
      }
    }

    // Escalações (partidas jogadas) — agora por id_jogador
    List<Map<String, dynamic>> partidas = await banco.rawQuery(
      "SELECT esc.id AS idEscalacao, pa.id AS idPartida, "
      "pa.qtd_gols_time_casa, pa.qtd_gols_time_visitante, pa.wo, "
      "r.numero AS numeroRodada, r.data AS dataRodada, "
      "c.nome AS nomeCompeticao, tc.nome_time AS timeCasa, "
      "tv.nome_time AS timeVisitante "
      "FROM escalacao esc "
      "JOIN partida pa ON esc.id_partida = pa.id "
      "JOIN rodada r ON pa.id_rodada = r.id "
      "JOIN competicao c ON r.id_competicao = c.id "
      "JOIN time tc ON pa.id_time_casa = tc.id_time "
      "JOIN time tv ON pa.id_time_visitante = tv.id_time "
      "WHERE esc.id_jogador = ? "
      "ORDER BY r.data DESC",
      [idJogador],
    );
    List<int> idsEsc = partidas.map((p) => p['idEscalacao'] as int).toList();

    // Eventos
    List<Map<String, dynamic>> eventos = [];
    if (idsEsc.isNotEmpty) {
      String placeholders = idsEsc.map((_) => '?').join(',');
      eventos = await banco.rawQuery(
        "SELECT ev.id, te.descricao AS tipoEvento, ev.minuto_evento, "
        "ev.descricao, ev.id_escalacao "
        "FROM evento_partida ev "
        "JOIN tipo_evento te ON ev.id_tipo_evento = te.id "
        "WHERE ev.id_escalacao IN ($placeholders) "
        "ORDER BY ev.minuto_evento",
        idsEsc,
      );
    }

    // Suspensões
    List<Map<String, dynamic>> suspensoes = [];
    if (idsEsc.isNotEmpty) {
      String placeholders = idsEsc.map((_) => '?').join(',');
      suspensoes = await banco.rawQuery(
        "SELECT s.id, s.motivo, s.qtd_jogos_suspensao, s.cumprida, "
        "te.descricao AS tipoEvento, ev.minuto_evento "
        "FROM suspensao s "
        "JOIN evento_partida ev ON s.id_evento = ev.id "
        "JOIN tipo_evento te ON ev.id_tipo_evento = te.id "
        "WHERE ev.id_escalacao IN ($placeholders)",
        idsEsc,
      );
    }

    return {
      'jogador': jogador.isNotEmpty ? jogador.first : {},
      'participacoes': participacoes,
      'pagamentos': pagamentos,
      'partidas': partidas,
      'eventos': eventos,
      'suspensoes': suspensoes,
    };
  }
}
