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

  // Consulta detalhada: traz o nome do jogador em vez do id
  Future<List<Map<String, dynamic>>> queryFindDetalhado([String? tipo]) async {
    Database banco = await BancoDados().db;

    String sql = "SELECT d.id AS id, d.tipo_documento AS tipoDocumento, "
        "d.caminho_arquivo AS caminhoArquivo, j.nome AS nomeJogador "
        "FROM documento d "
        "JOIN jogador j ON d.id_jogador = j.id";

    List<dynamic> args = [];

    if (tipo != null && tipo.isNotEmpty) {
      sql += " WHERE d.tipo_documento LIKE ?";
      args.add("%$tipo%");
    }

    sql += " ORDER BY j.nome";

    return await banco.rawQuery(sql, args);
  }
}
