import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/jogador.dart';
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

    return await BancoDados().inserir("jogador", jogador.toMap());
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
}
