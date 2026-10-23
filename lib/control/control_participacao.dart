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
    if (participacao.idJogador <= 0 || participacao.idTime <= 0) {
      throw RegraNegocioException(
        "Informe o jogador e o time da inscrição.",
      );
    }

    Database banco = await BancoDados().db;

    // RNFR-06.2 — jogador não se inscreve duas vezes no mesmo time
    List<Map<String, dynamic>> existente = await banco.query(
      "participacao_jogador_time",
      where: "id_jogador = ? AND id_time = ?",
      whereArgs: [participacao.idJogador, participacao.idTime],
    );
    if (existente.isNotEmpty) {
      throw RegraNegocioException(
        "Este jogador já está inscrito neste time.",
      );
    }

    // RNFR-06.1 — idade dentro da faixa da categoria do time
    List<Map<String, dynamic>> dados = await banco.rawQuery(
      "SELECT j.data_nascimento AS nascimento, "
      "c.idade_min AS idade_min, c.idade_max AS idade_max, "
      "j.nome AS nome_jogador, c.nome AS nome_categoria "
      "FROM jogador j "
      "INNER JOIN time t ON t.id_time = ? "
      "INNER JOIN categoria c ON c.id = t.id_categoria "
      "WHERE j.id = ?",
      [participacao.idTime, participacao.idJogador],
    );

    if (dados.isNotEmpty) {
      String nascimento = dados.first['nascimento'];
      int idadeMin = dados.first['idade_min'] ?? 0;
      int idadeMax = dados.first['idade_max'] ?? 0;
      String nomeJogador = dados.first['nome_jogador'];
      String nomeCategoria = dados.first['nome_categoria'];

      int idade = Validacoes.calcularIdade(nascimento);

      if (idade < idadeMin || idade > idadeMax) {
        throw RegraNegocioException(
          "O jogador $nomeJogador tem $idade ano(s) e a categoria "
          "$nomeCategoria permite de $idadeMin a $idadeMax ano(s).",
        );
      }
    }

    return await BancoDados().inserir(
      "participacao_jogador_time",
      participacao.toMap(),
    );
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
