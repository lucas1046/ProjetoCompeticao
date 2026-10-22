import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/participacao_jogador_time.dart';
import 'package:sqflite/sqflite.dart';

class ControlParticipacao {
  static final ControlParticipacao _instancia = ControlParticipacao._();

  ControlParticipacao._();

  factory ControlParticipacao() => _instancia;

  Future<int> insertDatabase(ParticipacaoJogadorTime participacao) async {
    Database banco = await BancoDados().db;
    return await banco.insert("participacao_jogador_time", participacao.toMap());
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
