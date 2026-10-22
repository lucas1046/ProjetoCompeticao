import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/rodada.dart';
import 'package:sqflite/sqflite.dart';

class ControlRodada {
  static final ControlRodada _instancia = ControlRodada._();

  ControlRodada._();

  factory ControlRodada() => _instancia;

  Future<int> insertDatabase(Rodada rodada) async {
    Database banco = await BancoDados().db;
    return await banco.insert("rodada", rodada.toMap());
  }

  Future<List<Rodada>> queryFind() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados = await banco.query("rodada");

    return List.generate(resultados.length, (i) {
      return Rodada.fromMap(resultados[i]);
    });
  }
}
