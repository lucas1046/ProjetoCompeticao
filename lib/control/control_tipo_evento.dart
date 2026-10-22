import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:sqflite/sqflite.dart';

class ControlTipoEvento {
  static final ControlTipoEvento _instancia = ControlTipoEvento._();

  ControlTipoEvento._();

  factory ControlTipoEvento() => _instancia;

  Future<int> insertDatabase(TipoEvento tipoEvento) async {
    Database banco = await BancoDados().db;
    return await banco.insert("tipo_evento", tipoEvento.toMap());
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
