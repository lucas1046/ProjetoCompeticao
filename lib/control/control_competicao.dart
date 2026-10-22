import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:sqflite/sqflite.dart';

class ControlCompeticao {
  static final ControlCompeticao _instancia = ControlCompeticao._();

  ControlCompeticao._();

  factory ControlCompeticao() => _instancia;

  // ---------------------------------------------------------
  // CRUD - COMPETIÇÃO
  // ---------------------------------------------------------

  // Realiza o insert dos dados passando o objeto competicao
  Future<int> insertDatabase(Competicao competicao) async {
    Database banco = await BancoDados().db;
    return await banco.insert("competicao", competicao.toMap());
  }

  // Realiza a consulta dos dados, aceita um filtro por nome
  Future<List<Competicao>> queryFind([String? nome]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "competicao",
        where: "nome LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("competicao");
    }

    return List.generate(resultados.length, (i) {
      return Competicao.fromMap(resultados[i]);
    });
  }
}
