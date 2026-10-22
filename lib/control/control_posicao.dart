import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/posicao.dart';
import 'package:sqflite/sqflite.dart';

class ControlPosicao {
  static final ControlPosicao _instancia = ControlPosicao._();

  ControlPosicao._();

  factory ControlPosicao() => _instancia;

  Future<int> insertDatabase(Posicao posicao) async {
    Database banco = await BancoDados().db;
    return await banco.insert("posicao", posicao.toMap());
  }

  Future<List<Posicao>> queryFind([String? nome]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "posicao",
        where: "nome LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("posicao");
    }

    return List.generate(resultados.length, (i) {
      return Posicao.fromMap(resultados[i]);
    });
  }
}
