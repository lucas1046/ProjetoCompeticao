import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaRelatorioPartidas extends StatefulWidget {
  const TelaRelatorioPartidas({super.key});

  @override
  State<TelaRelatorioPartidas> createState() => _TelaRelatorioPartidasState();
}

class _TelaRelatorioPartidasState extends State<TelaRelatorioPartidas> {
  String _resultado = "";
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico de partidas"),
        backgroundColor: Colors.purple,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Buttons("Gerar relatório", onPressed: _carregando ? null : () { _gerar(); }),
        SizedBox(height: 16),
        if (_carregando) Center(child: CircularProgressIndicator()),
        TextosCustom(_resultado, 16, Colors.black),
      ],
    );
  }

  Future _gerar() async {
    setState(() {
      _carregando = true;
      _resultado = "";
    });

    ControlRelatorio control = ControlRelatorio();
    List<Map<String, dynamic>> lista = await control.historicoPartidas();

    String texto = "COMPETIÇÃO           ROD  CASA              X  VISITANTE\n"
        "--------------------------------------------------------------\n";

    for (Map<String, dynamic> p in lista) {
      String competicao = (p['nomeCompeticao'] as String).padRight(18);
      String rodada = (p['numeroRodada']?.toString() ?? "-").padLeft(3);
      String casa = (p['timeCasa'] as String).padRight(16);
      String visitante = p['timeVisitante'] as String;
      int golsCasa = p['golsCasa'] as int? ?? 0;
      int golsVisitante = p['golsVisitante'] as int? ?? 0;
      bool wo = p['wo'] == 1;

      texto += "$competicao $rodada  $casa $golsCasa x $golsVisitante $visitante";
      if (wo) {
        texto += "  (WO)";
      }
      texto += "\n";
    }

    if (lista.isEmpty) {
      texto += "Nenhuma partida registrada ainda.\n";
    }

    setState(() {
      _resultado = texto;
      _carregando = false;
    });
  }
}
