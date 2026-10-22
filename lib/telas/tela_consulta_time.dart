import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_time.dart';
import 'package:projeto_final/model/time.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaTime extends StatefulWidget {
  const TelaConsultaTime({super.key});

  @override
  State<TelaConsultaTime> createState() => _TelaConsultaTimeState();
}

class _TelaConsultaTimeState extends State<TelaConsultaTime> {
  String textoPesquisa = "";
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar time"),
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
    ControlTime control = ControlTime();
    List<Time> lista = await control.queryFind(_inputPesquisa.text);

    String texto = "";
    for (Time t in lista) {
      texto +=
          "${t.idTime} - ${t.nomeTime} - escola: ${t.idEscola} - categoria: ${t.idCategoria}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
