import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_escalacao.dart';
import 'package:projeto_final/model/escalacao.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaEscalacao extends StatefulWidget {
  const TelaConsultaEscalacao({super.key});

  @override
  State<TelaConsultaEscalacao> createState() => _TelaConsultaEscalacaoState();
}

class _TelaConsultaEscalacaoState extends State<TelaConsultaEscalacao> {
  String textoPesquisa = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar escalações"),
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
    ControlEscalacao control = ControlEscalacao();
    List<Escalacao> lista = await control.queryFind();

    String texto = "";
    for (Escalacao e in lista) {
      texto += "${e.id} - partida ${e.idPartida} - camisa ${e.numeroCamisa} - ${e.titular}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
