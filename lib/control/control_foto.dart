import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/foto_figurinha.dart';
import 'package:sqflite/sqflite.dart';

class ControlFoto {
  static final ControlFoto _instancia = ControlFoto._();

  ControlFoto._();

  factory ControlFoto() => _instancia;

  Future<int> insertDatabase(FotoFigurinha foto) async {
    Database banco = await BancoDados().db;
    return await banco.insert("foto_figurinha", foto.toMap());
  }

  Future<List<FotoFigurinha>> queryFind([String? caminho]) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados;

    if (caminho != null && caminho.isNotEmpty) {
      resultados = await banco.query(
        "foto_figurinha",
        where: "caminho_arquivo LIKE ?",
        whereArgs: ["%$caminho%"],
      );
    } else {
      resultados = await banco.query("foto_figurinha");
    }

    return List.generate(resultados.length, (i) {
      return FotoFigurinha.fromMap(resultados[i]);
    });
  }
}
