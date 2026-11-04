import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

class ControlCategoria {
  static final ControlCategoria _instancia = ControlCategoria._();

  ControlCategoria._();

  factory ControlCategoria() => _instancia;

  // RNFR-02.1 — idade mínima menor que a máxima
  Future<int> insertDatabase(Categoria categoria) async {
    if (categoria.nome.trim().isEmpty) {
      throw RegraNegocioException("Informe o nome da categoria.");
    }
    if (categoria.idadeMin >= categoria.idadeMax) {
      throw RegraNegocioException(
        "A idade mínima deve ser menor que a idade máxima.",
      );
    }
    if (categoria.idadeMin < 0 || categoria.idadeMax < 0) {
      throw RegraNegocioException("As idades não podem ser negativas.");
    }
    return await BancoDados().inserir("categoria", categoria.toMap());
  }

  Future<void> updateDatabase(Categoria categoria) async {
    Database banco = await BancoDados().db;
    await banco.update("categoria", categoria.toMap(), where: "id = ?", whereArgs: [categoria.id]);
  }

  // RNFR-02.2 — não permite excluir categoria com times vinculados
  Future<int> deleteDatabase(int id) async {
    Database banco = await BancoDados().db;

    List<Map<String, dynamic>> vinculados = await banco.query(
      "time",
      where: "id_categoria = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (vinculados.isNotEmpty) {
      throw RegraNegocioException(
        "Não é possível excluir: existem times vinculados a esta categoria.",
      );
    }

    return await banco.delete(
      "categoria",
      where: "id = ?",
      whereArgs: [id],
    );
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
