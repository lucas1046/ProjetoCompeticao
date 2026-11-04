import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/participacao_jogador_time.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

class ControlParticipacao {
  static final ControlParticipacao _instancia = ControlParticipacao._();

  ControlParticipacao._();

  factory ControlParticipacao() => _instancia;

  // RNFR-06.1 e RNFR-06.2
  Future<int> insertDatabase(ParticipacaoJogadorTime participacao) async {
    if (participacao.idJogador <= 0) {
      throw RegraNegocioException("Informe o jogador da inscrição.");
    }

    Database banco = await BancoDados().db;

    // RNFR-06.2 — jogador não se inscreve duas vezes na mesma escola
    List<Map<String, dynamic>> existente = await banco.query(
      "participacao_jogador_time",
      where: "id_jogador = ? AND id_escola = ?",
      whereArgs: [participacao.idJogador, participacao.idEscola],
    );
    if (existente.isNotEmpty) {
      throw RegraNegocioException(
        "Este jogador já está inscrito nesta escola.",
      );
    }

    return await BancoDados().inserir(
      "participacao_jogador_time",
      participacao.toMap(),
    );
  }

  Future<void> updateDatabase(ParticipacaoJogadorTime participacao) async {
    Database banco = await BancoDados().db;
    await banco.update("participacao_jogador_time", participacao.toMap(), where: "id = ?", whereArgs: [participacao.id]);
  }

  Future<List<ParticipacaoJogadorTime>> queryFind() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados =
        await banco.query("participacao_jogador_time");

    return List.generate(resultados.length, (i) {
      return ParticipacaoJogadorTime.fromMap(resultados[i]);
    });
  }
}
