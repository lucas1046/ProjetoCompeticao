import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/responsavel.dart';
import 'package:sqflite/sqflite.dart';

class ControlResponsavel {
  static final ControlResponsavel _instancia = ControlResponsavel._();

  ControlResponsavel._();

  factory ControlResponsavel() => _instancia;

  Future<int> insertDatabase(Responsavel responsavel) async {
    Database banco = await BancoDados().db;
    return await banco.insert("responsavel", responsavel.toMap());
  }

  Future<List<Responsavel>> queryFind([String? nome]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "responsavel",
        where: "nome LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("responsavel");
    }

    return List.generate(resultados.length, (i) {
      return Responsavel.fromMap(resultados[i]);
    });
  }
}
