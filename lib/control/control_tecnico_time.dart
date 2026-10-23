import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/tecnico_time.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

class ControlTecnicoTime {
  static final ControlTecnicoTime _instancia = ControlTecnicoTime._();

  ControlTecnicoTime._();

  factory ControlTecnicoTime() => _instancia;

  // RNFR-07.1 — o tecnico pode estar em varios times, mas cada vinculo
  // (tecnico + time) e unico e registrado de forma independente
  Future<int> insertDatabase(TecnicoTime tecnicoTime) async {
    if (tecnicoTime.idTecnico <= 0 || tecnicoTime.idTime <= 0) {
      throw RegraNegocioException("Informe o técnico e o time do vínculo.");
    }

    Database banco = await BancoDados().db;

    List<Map<String, dynamic>> existente = await banco.query(
      "tecnico_time",
      where: "id_tecnico = ? AND id_time = ?",
      whereArgs: [tecnicoTime.idTecnico, tecnicoTime.idTime],
      limit: 1,
    );

    if (existente.isNotEmpty) {
      throw RegraNegocioException(
        "Este técnico já está vinculado a este time.",
      );
    }

    return await BancoDados().inserir("tecnico_time", tecnicoTime.toMap());
  }

  // RNFR-07.1 — lista todos os vinculos de um tecnico
  Future<List<TecnicoTime>> queryFindPorTecnico(int idTecnico) async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados = await banco.query(
      "tecnico_time",
      where: "id_tecnico = ?",
      whereArgs: [idTecnico],
    );

    return List.generate(resultados.length, (i) {
      return TecnicoTime.fromMap(resultados[i]);
    });
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
