import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:sqflite/sqflite.dart';

class ControlJogador {
  static final ControlJogador _instancia = ControlJogador._();

  ControlJogador._();

  factory ControlJogador() => _instancia;

  Future<int> insertDatabase(Jogador jogador) async {
    Database banco = await BancoDados().db;
    return await banco.insert("jogador", jogador.toMap());
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
