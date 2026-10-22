import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:sqflite/sqflite.dart';

class ControlCategoria {
  static final ControlCategoria _instancia = ControlCategoria._();

  ControlCategoria._();

  factory ControlCategoria() => _instancia;

  Future<int> insertDatabase(Categoria categoria) async {
    Database banco = await BancoDados().db;
    return await banco.insert("categoria", categoria.toMap());
  }

  Future<List<Categoria>> queryFind([String? nome]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "categoria",
        where: "nome LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("categoria");
    }

    return List.generate(resultados.length, (i) {
      return Categoria.fromMap(resultados[i]);
    });
  }
}
