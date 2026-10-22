import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_tipo_evento.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaTipoEvento extends StatefulWidget {
  const TelaConsultaTipoEvento({super.key});

  @override
  State<TelaConsultaTipoEvento> createState() => _TelaConsultaTipoEventoState();
}

class _TelaConsultaTipoEventoState extends State<TelaConsultaTipoEvento> {
  String textoPesquisa = "";
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar tipo de evento"),
        backgroundColor: Colors.orange,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos(
          "",
          "Digite uma descrição para pesquisa",
          controller: _inputPesquisa,
        ),
        Buttons("Pesquisar", onPressed: _pesquisar),
        TextosCustom(textoPesquisa, 18, Colors.red),
      ],
    );
  }

  Future _pesquisar() async {
    ControlTipoEvento control = ControlTipoEvento();
    List<TipoEvento> lista = await control.queryFind(_inputPesquisa.text);

    String texto = "";
    for (TipoEvento t in lista) {
      texto += "${t.id} - ${t.descricao}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
