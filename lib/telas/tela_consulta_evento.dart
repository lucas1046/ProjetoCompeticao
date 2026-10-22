import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_evento.dart';
import 'package:projeto_final/model/evento_partida.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaEvento extends StatefulWidget {
  const TelaConsultaEvento({super.key});

  @override
  State<TelaConsultaEvento> createState() => _TelaConsultaEventoState();
}

class _TelaConsultaEventoState extends State<TelaConsultaEvento> {
  String textoPesquisa = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar eventos"),
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
    ControlEvento control = ControlEvento();
    List<EventoPartida> lista = await control.queryFind();

    String texto = "";
    for (EventoPartida e in lista) {
      texto += "${e.id} - ${e.minutoEvento}' - tipo ${e.idTipoEvento} - ${e.descricao}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
