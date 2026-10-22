import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/partida.dart';
import 'package:sqflite/sqflite.dart';

class ControlPartida {
  static final ControlPartida _instancia = ControlPartida._();

  ControlPartida._();

  factory ControlPartida() => _instancia;

  Future<int> insertDatabase(Partida partida) async {
    Database banco = await BancoDados().db;
    return await banco.insert("partida", partida.toMap());
  }

  Future<List<Partida>> queryFind() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados = await banco.query("partida");

    return List.generate(resultados.length, (i) {
      return Partida.fromMap(resultados[i]);
    });
  }
}
