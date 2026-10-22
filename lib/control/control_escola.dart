import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:sqflite/sqflite.dart';

class ControlEscola {
  static final ControlEscola _instancia = ControlEscola._();

  ControlEscola._();

  factory ControlEscola() => _instancia;

  Future<int> insertDatabase(Escola escola) async {
    Database banco = await BancoDados().db;
    return await banco.insert("escola", escola.toMap());
  }

  Future<List<Escola>> queryFind([String? nome]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "escola",
        where: "nome LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("escola");
    }

    return List.generate(resultados.length, (i) {
      return Escola.fromMap(resultados[i]);
    });
  }
}
