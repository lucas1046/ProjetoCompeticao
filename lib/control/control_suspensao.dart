import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/suspensao.dart';
import 'package:sqflite/sqflite.dart';

class ControlSuspensao {
  static final ControlSuspensao _instancia = ControlSuspensao._();

  ControlSuspensao._();

  factory ControlSuspensao() => _instancia;

  Future<int> insertDatabase(Suspensao suspensao) async {
    Database banco = await BancoDados().db;
    return await banco.insert("suspensao", suspensao.toMap());
  }

  Future<List<Suspensao>> queryFind([String? motivo]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (motivo != null && motivo.isNotEmpty) {
      resultados = await banco.query(
        "suspensao",
        where: "motivo LIKE ?",
        whereArgs: ["%$motivo%"],
      );
    } else {
      resultados = await banco.query("suspensao");
    }

    return List.generate(resultados.length, (i) {
      return Suspensao.fromMap(resultados[i]);
    });
  }
}
