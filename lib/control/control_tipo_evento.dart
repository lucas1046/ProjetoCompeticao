import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:sqflite/sqflite.dart';

class ControlTipoEvento {
  static final ControlTipoEvento _instancia = ControlTipoEvento._();

  ControlTipoEvento._();

  factory ControlTipoEvento() => _instancia;

  Future<int> insertDatabase(TipoEvento tipoEvento) async {
    return await BancoDados().inserir("tipo_evento", tipoEvento.toMap());
  }

  Future<void> updateDatabase(TipoEvento tipoEvento) async {
    Database banco = await BancoDados().db;
    await banco.update("tipo_evento", tipoEvento.toMap(), where: "id = ?", whereArgs: [tipoEvento.id]);
  }

  Future<List<TipoEvento>> queryFind([String? descricao]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (descricao != null && descricao.isNotEmpty) {
      resultados = await banco.query(
        "tipo_evento",
        where: "descricao LIKE ?",
        whereArgs: ["%$descricao%"],
      );
    } else {
      resultados = await banco.query("tipo_evento");
    }

    return List.generate(resultados.length, (i) {
      return TipoEvento.fromMap(resultados[i]);
    });
  }
}
