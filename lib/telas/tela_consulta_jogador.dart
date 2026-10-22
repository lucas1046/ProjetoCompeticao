import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaJogador extends StatefulWidget {
  const TelaConsultaJogador({super.key});

  @override
  State<TelaConsultaJogador> createState() => _TelaConsultaJogadorState();
}

class _TelaConsultaJogadorState extends State<TelaConsultaJogador> {
  String textoPesquisa = "";
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar jogador"),
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
    ControlJogador control = ControlJogador();
    List<Jogador> lista = await control.queryFind(_inputPesquisa.text);

    String texto = "";
    for (Jogador j in lista) {
      texto += "${j.id} - ${j.nome} - ${j.cpf} - responsável: ${j.idResponsavel}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
