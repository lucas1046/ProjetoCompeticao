import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/foto_figurinha.dart';
import 'package:projeto_final/util/validacao_arquivo.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

class ControlFoto {
  static final ControlFoto _instancia = ControlFoto._();

  ControlFoto._();

  factory ControlFoto() => _instancia;

  Future<int> insertDatabase(FotoFigurinha foto) async {
    String? erroImagem = await validarImagem(foto.caminhoArquivo);
    if (erroImagem != null) {
      throw RegraNegocioException(erroImagem);
    }
    if (!Validacoes.dataValida(foto.dataUpload)) {
      throw RegraNegocioException(
        "Data de upload inválida. Use o formato dd/MM/yyyy.",
      );
    }
    return await BancoDados().inserir("foto_figurinha", foto.toMap());
  }

  Future<void> updateDatabase(FotoFigurinha foto) async {
    Database banco = await BancoDados().db;
    await banco.update("foto_figurinha", foto.toMap(), where: "id = ?", whereArgs: [foto.id]);
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
