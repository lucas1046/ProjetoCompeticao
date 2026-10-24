import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/posicao.dart';
import 'package:sqflite/sqflite.dart';

class ControlPosicao {
  static final ControlPosicao _instancia = ControlPosicao._();

  ControlPosicao._();

  factory ControlPosicao() => _instancia;

  Future<int> insertDatabase(Posicao posicao) async {
    return await BancoDados().inserir("posicao", posicao.toMap());
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

  // Consulta detalhada: traz o nome da modalidade em vez do id
  Future<List<Map<String, dynamic>>> queryFindDetalhado([String? nome]) async {
    Database banco = await BancoDados().db;

    String sql = "SELECT p.id AS id, p.nome AS nome, "
        "m.nome AS nomeModalidade "
        "FROM posicao p "
        "JOIN modalidade m ON p.id_modalidade = m.id";

    List<dynamic> args = [];

    if (nome != null && nome.isNotEmpty) {
      sql += " WHERE p.nome LIKE ?";
      args.add("%$nome%");
    }

    sql += " ORDER BY p.nome";

    return await banco.rawQuery(sql, args);
  }
}
