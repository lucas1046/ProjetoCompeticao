import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/tecnico.dart';
import 'package:sqflite/sqflite.dart';

class ControlTecnico {
  static final ControlTecnico _instancia = ControlTecnico._();

  ControlTecnico._();

  factory ControlTecnico() => _instancia;

  Future<int> insertDatabase(Tecnico tecnico) async {
    Database banco = await BancoDados().db;
    return await banco.insert("tecnico", tecnico.toMap());
  }

  Future<List<Tecnico>> queryFind([String? nome]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "tecnico",
        where: "nome LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("tecnico");
    }

    return List.generate(resultados.length, (i) {
      return Tecnico.fromMap(resultados[i]);
    });
  }
}
