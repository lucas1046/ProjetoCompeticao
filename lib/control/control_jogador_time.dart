import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/jogador_time.dart';
import 'package:sqflite/sqflite.dart';

class ControlJogadorTime {
  static final ControlJogadorTime _instancia = ControlJogadorTime._();
  ControlJogadorTime._();
  factory ControlJogadorTime() => _instancia;

  Future<int> insertDatabase(JogadorTime jt) async {
    Database banco = await BancoDados().db;
    return await banco.insert("jogador_time", jt.toMap());
  }

  Future<List<JogadorTime>> queryFind() async {
    Database banco = await BancoDados().db;
    final res = await banco.query("jogador_time");
    return res.map((m) => JogadorTime.fromMap(m)).toList();
  }

  Future<List<Map<String, dynamic>>> queryByTime(int idTime) async {
    Database banco = await BancoDados().db;
    return await banco.rawQuery(
      "SELECT jt.id, jt.id_posicao AS idPosicao, jt.numero_camisa, j.id AS idJogador, j.nome AS nomeJogador, p.nome AS nomePosicao "
      "FROM jogador_time jt "
      "JOIN jogador j ON jt.id_jogador = j.id "
      "LEFT JOIN posicao p ON jt.id_posicao = p.id "
      "WHERE jt.id_time = ?",
      [idTime],
    );
  }

  Future<void> deleteByTime(int idTime) async {
    Database banco = await BancoDados().db;
    await banco.delete("jogador_time", where: "id_time = ?", whereArgs: [idTime]);
  }
}