import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_posicao.dart';
import 'package:projeto_final/model/posicao.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaPosicao extends StatefulWidget {
  const TelaConsultaPosicao({super.key});

  @override
  State<TelaConsultaPosicao> createState() => _TelaConsultaPosicaoState();
}

class _TelaConsultaPosicaoState extends State<TelaConsultaPosicao> {
  String textoPesquisa = "";
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar posição"),
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
    ControlPosicao control = ControlPosicao();
    List<Posicao> lista = await control.queryFind(_inputPesquisa.text);

    String texto = "";
    for (Posicao p in lista) {
      texto += "${p.id} - ${p.nome} (modalidade: ${p.idModalidade})\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
