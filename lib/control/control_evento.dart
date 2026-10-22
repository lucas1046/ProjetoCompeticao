import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/evento_partida.dart';
import 'package:sqflite/sqflite.dart';

class ControlEvento {
  static final ControlEvento _instancia = ControlEvento._();

  ControlEvento._();

  factory ControlEvento() => _instancia;

  Future<int> insertDatabase(EventoPartida evento) async {
    Database banco = await BancoDados().db;
    return await banco.insert("evento_partida", evento.toMap());
  }

  Future<List<EventoPartida>> queryFind() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados =
        await banco.query("evento_partida");

    return List.generate(resultados.length, (i) {
      return EventoPartida.fromMap(resultados[i]);
    });
  }
}
