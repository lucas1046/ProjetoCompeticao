import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_partida.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaPartida extends StatefulWidget {
  const TelaConsultaPartida({super.key});

  @override
  State<TelaConsultaPartida> createState() => _TelaConsultaPartidaState();
}

class _TelaConsultaPartidaState extends State<TelaConsultaPartida> {
  String textoPesquisa = "";
  List<Map<String, dynamic>> _lista = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar partidas"),
        backgroundColor: Colors.orange,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Buttons("Pesquisar", onPressed: _pesquisar),
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom(
            textoPesquisa.isEmpty
                ? "Toque em pesquisar para listar as partidas."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map(_cartao),
      ],
    );
  }

  Widget _cartao(Map<String, dynamic> p) {
    int golsCasa = (p['golsCasa'] as num?)?.toInt() ?? 0;
    int golsVisitante = (p['golsVisitante'] as num?)?.toInt() ?? 0;
    bool wo = p['wo'] == 1;

    String resultado = "$golsCasa x $golsVisitante";
    if (wo) {
      resultado = "WO";
    }

    return CartaoConsulta(
      "${p['nomeTimeCasa']} x ${p['nomeTimeVisitante']}",
      [
        "${p['nomeCompeticao']} - Rodada ${p['numeroRodada']}",
      ],
      selo: resultado,
      corSelo: Colors.blue,
      icone: Icons.sports_score,
    );
  }

  Future _pesquisar() async {
    ControlPartida control = ControlPartida();
    List<Map<String, dynamic>> lista = await control.queryFindDetalhado();

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhuma partida encontrada." : "";
    });
  }
}
