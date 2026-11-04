import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/evento_partida.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

class ControlEvento {
  static final ControlEvento _instancia = ControlEvento._();

  ControlEvento._();

  factory ControlEvento() => _instancia;

  // RNFR-11.1 e RNFR-11.2
  Future<int> insertDatabase(EventoPartida evento) async {
    if (evento.idTipoEvento <= 0) {
      throw RegraNegocioException("Selecione o tipo de evento.");
    }

    if (evento.idEscalacao <= 0) {
      throw RegraNegocioException("Selecione o jogador escalado.");
    }

    if (evento.minutoEvento < 0 || evento.minutoEvento > 130) {
      throw RegraNegocioException(
        "O minuto do evento deve estar entre 0 e 130.",
      );
    }

    Database banco = await BancoDados().db;

    // RNFR-11.2 — tipo de evento deve estar previamente cadastrado
    List<Map<String, dynamic>> tipo = await banco.query(
      "tipo_evento",
      where: "id = ?",
      whereArgs: [evento.idTipoEvento],
      limit: 1,
    );
    if (tipo.isEmpty) {
      throw RegraNegocioException(
        "Tipo de evento inválido. Cadastre-o primeiro.",
      );
    }

    // RNFR-11.1 — evento só pode ser vinculado a jogador escalado
    List<Map<String, dynamic>> escalacao = await banco.query(
      "escalacao",
      where: "id = ?",
      whereArgs: [evento.idEscalacao],
      limit: 1,
    );
    if (escalacao.isEmpty) {
      throw RegraNegocioException(
        "Escalação não encontrada. O evento deve pertencer a um jogador escalado.",
      );
    }

    return await BancoDados().inserir("evento_partida", evento.toMap());
  }

  Future<void> updateDatabase(EventoPartida evento) async {
    Database banco = await BancoDados().db;
    await banco.update("evento_partida", evento.toMap(), where: "id = ?", whereArgs: [evento.id]);
  }

  Future<void> deleteDatabase(int id) async {
    Database banco = await BancoDados().db;
    await banco.delete("evento_partida", where: "id = ?", whereArgs: [id]);
  }

  // Consulta detalhada: traz o tipo de evento e o jogador em vez dos ids
  Future<List<Map<String, dynamic>>> queryFindDetalhado() async {
    Database banco = await BancoDados().db;

    return await banco.rawQuery(
      "SELECT ep.id AS id, ep.minuto_evento AS minuto, "
      "ep.descricao AS descricao, te.descricao AS tipoEvento, "
      "j.nome AS nomeJogador, t.nome_time AS nomeTime "
      "FROM evento_partida ep "
      "JOIN tipo_evento te ON ep.id_tipo_evento = te.id "
      "JOIN escalacao e ON ep.id_escalacao = e.id "
      "JOIN jogador j ON e.id_jogador = j.id "
      "LEFT JOIN time t ON e.id_time = t.id_time "
      "ORDER BY ep.minuto_evento",
    );
  }

  Future<List<EventoPartida>> queryFind() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados =
        await banco.query("evento_partida");

    return List.generate(resultados.length, (i) {
      return EventoPartida.fromMap(resultados[i]);
    });
  }
}
