import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/modalidade.dart';
import 'package:sqflite/sqflite.dart';

class ControlModalidade {
  static final ControlModalidade _instancia = ControlModalidade._();

  ControlModalidade._();

  factory ControlModalidade() => _instancia;

  Future<int> insertDatabase(Modalidade modalidade) async {
    Database banco = await BancoDados().db;
    return await banco.insert("modalidade", modalidade.toMap());
  }

  Future<List<Modalidade>> queryFind([String? nome]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "modalidade",
        where: "nome LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("modalidade");
    }

    return List.generate(resultados.length, (i) {
      return Modalidade.fromMap(resultados[i]);
    });
  }
}
