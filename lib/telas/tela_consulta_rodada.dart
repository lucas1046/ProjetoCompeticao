import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_rodada.dart';
import 'package:projeto_final/model/rodada.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaRodada extends StatefulWidget {
  const TelaConsultaRodada({super.key});

  @override
  State<TelaConsultaRodada> createState() => _TelaConsultaRodadaState();
}

class _TelaConsultaRodadaState extends State<TelaConsultaRodada> {
  String textoPesquisa = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar rodadas"),
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
    ControlRodada control = ControlRodada();
    List<Rodada> lista = await control.queryFind();

    String texto = "";
    for (Rodada r in lista) {
      texto += "${r.id} - rodada ${r.numero} - ${r.data} - competição: ${r.idCompeticao}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
