import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_partida.dart';
import 'package:projeto_final/model/partida.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaPartida extends StatefulWidget {
  const TelaConsultaPartida({super.key});

  @override
  State<TelaConsultaPartida> createState() => _TelaConsultaPartidaState();
}

class _TelaConsultaPartidaState extends State<TelaConsultaPartida> {
  String textoPesquisa = "";

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
        TextosCustom(textoPesquisa, 18, Colors.red),
      ],
    );
  }

  Future _pesquisar() async {
    ControlPartida control = ControlPartida();
    List<Partida> lista = await control.queryFind();

    String texto = "";
    for (Partida p in lista) {
      texto += "${p.id} - casa ${p.idTimeCasa} ${p.qtdGolsTimeCasa} x "
          "${p.qtdGolsTimeVisitante} ${p.idTimeVisitante} - WO: ${p.wo}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
