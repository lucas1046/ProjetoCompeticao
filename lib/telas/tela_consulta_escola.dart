import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_escola.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaEscola extends StatefulWidget {
  const TelaConsultaEscola({super.key});

  @override
  State<TelaConsultaEscola> createState() => _TelaConsultaEscolaState();
}

class _TelaConsultaEscolaState extends State<TelaConsultaEscola> {
  String textoPesquisa = "";
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar escola"),
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
          "Digite um nome para pesquisa",
          controller: _inputPesquisa,
        ),
        Buttons("Pesquisar", onPressed: _pesquisar),
        TextosCustom(textoPesquisa, 18, Colors.red),
      ],
    );
  }

  Future _pesquisar() async {
    ControlEscola control = ControlEscola();
    List<Escola> lista = await control.queryFind(_inputPesquisa.text);

    String texto = "";
    for (Escola e in lista) {
      texto += "${e.id} - ${e.nome} - ${e.cidade}/${e.estado}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
