import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/control/control_suspensao.dart';
import 'package:projeto_final/model/partida.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

class ControlPartida {
  static final ControlPartida _instancia = ControlPartida._();

  ControlPartida._();

  factory ControlPartida() => _instancia;

  // RNFR-09.1, RNFR-09.2 e RNFR-09.3
  Future<int> insertDatabase(Partida partida) async {
    // RNFR-09.1 — partida exige os dois times
    if (partida.idTimeCasa <= 0 || partida.idTimeVisitante <= 0) {
      throw RegraNegocioException(
        "Informe o time da casa e o time visitante.",
      );
    }

    // RNFR-09.2 — o mesmo time não pode ser casa e visitante
    if (partida.idTimeCasa == partida.idTimeVisitante) {
      throw RegraNegocioException(
        "O time da casa e o time visitante devem ser diferentes.",
      );
    }

    if (partida.qtdGolsTimeCasa < 0 || partida.qtdGolsTimeVisitante < 0) {
      throw RegraNegocioException("A quantidade de gols não pode ser negativa.");
    }

    // RNFR-09.3 — em caso de WO, indicar o time que recebeu
    if (partida.wo && partida.idTimeWo == null) {
      throw RegraNegocioException(
        "Em caso de WO, informe qual time recebeu a WO.",
      );
    }

    if (!partida.wo && partida.idTimeWo != null) {
      throw RegraNegocioException(
        "Há um time de WO informado mas a partida não foi marcada como WO.",
      );
    }

    int id = await BancoDados().inserir("partida", partida.toMap());

    // RNFR-12.2 — uma nova partida pode encerrar suspensoes em aberto
    await ControlSuspensao().atualizarSuspensoes();

    return id;
  }

  Future<List<Partida>> queryFind() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados = await banco.query("partida");

    return List.generate(resultados.length, (i) {
      return Partida.fromMap(resultados[i]);
    });
  }

  // Partidas com os nomes dos times, da rodada e da competição
  Future<List<Map<String, dynamic>>> queryFindDetalhado() async {
    Database banco = await BancoDados().db;

    return await banco.rawQuery(
      "SELECT p.id AS id, "
      "tc.nome_time AS nomeTimeCasa, "
      "tv.nome_time AS nomeTimeVisitante, "
      "p.qtd_gols_time_casa AS golsCasa, "
      "p.qtd_gols_time_visitante AS golsVisitante, "
      "p.wo AS wo, "
      "r.numero AS numeroRodada, "
      "c.nome AS nomeCompeticao "
      "FROM partida p "
      "JOIN time tc ON p.id_time_casa = tc.id_time "
      "JOIN time tv ON p.id_time_visitante = tv.id_time "
      "JOIN rodada r ON p.id_rodada = r.id "
      "JOIN competicao c ON r.id_competicao = c.id "
      "ORDER BY c.nome, r.numero",
    );
  }
}
