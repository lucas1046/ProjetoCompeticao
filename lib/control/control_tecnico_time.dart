import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/tecnico_time.dart';
import 'package:sqflite/sqflite.dart';

class ControlTecnicoTime {
  static final ControlTecnicoTime _instancia = ControlTecnicoTime._();

  ControlTecnicoTime._();

  factory ControlTecnicoTime() => _instancia;

  Future<int> insertDatabase(TecnicoTime tecnicoTime) async {
    Database banco = await BancoDados().db;
    return await banco.insert("tecnico_time", tecnicoTime.toMap());
  }

  Future<List<TecnicoTime>> queryFind() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados =
        await banco.query("tecnico_time");

    return List.generate(resultados.length, (i) {
      return TecnicoTime.fromMap(resultados[i]);
    });
  }
}
