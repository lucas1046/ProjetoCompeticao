import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/escalacao.dart';
import 'package:sqflite/sqflite.dart';

class ControlEscalacao {
  static final ControlEscalacao _instancia = ControlEscalacao._();

  ControlEscalacao._();

  factory ControlEscalacao() => _instancia;

  Future<int> insertDatabase(Escalacao escalacao) async {
    Database banco = await BancoDados().db;
    return await banco.insert("escalacao", escalacao.toMap());
  }

  Future<List<Escalacao>> queryFind() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados = await banco.query("escalacao");

    return List.generate(resultados.length, (i) {
      return Escalacao.fromMap(resultados[i]);
    });
  }
}
