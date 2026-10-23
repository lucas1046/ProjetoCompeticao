import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/documento.dart';
import 'package:sqflite/sqflite.dart';

class ControlDocumento {
  static final ControlDocumento _instancia = ControlDocumento._();

  ControlDocumento._();

  factory ControlDocumento() => _instancia;

  Future<int> insertDatabase(Documento documento) async {
    return await BancoDados().inserir("documento", documento.toMap());
  }

  Future<List<Documento>> queryFind([String? tipo]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (tipo != null && tipo.isNotEmpty) {
      resultados = await banco.query(
        "documento",
        where: "tipo_documento LIKE ?",
        whereArgs: ["%$tipo%"],
      );
    } else {
      resultados = await banco.query("documento");
    }

    return List.generate(resultados.length, (i) {
      return Documento.fromMap(resultados[i]);
    });
  }
}
