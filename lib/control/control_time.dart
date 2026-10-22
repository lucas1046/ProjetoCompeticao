import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/time.dart';
import 'package:sqflite/sqflite.dart';

class ControlTime {
  static final ControlTime _instancia = ControlTime._();

  ControlTime._();

  factory ControlTime() => _instancia;

  Future<int> insertDatabase(Time time) async {
    Database banco = await BancoDados().db;
    return await banco.insert("time", time.toMap());
  }

  Future<List<Time>> queryFind([String? nome]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "time",
        where: "nome_time LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("time");
    }

    return List.generate(resultados.length, (i) {
      return Time.fromMap(resultados[i]);
    });
  }
}
