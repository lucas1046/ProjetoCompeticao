import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_competicao.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaCompeticao extends StatefulWidget {
  const TelaConsultaCompeticao({super.key});

  @override
  State<TelaConsultaCompeticao> createState() => _TelaConsultaCompeticaoState();
}

class _TelaConsultaCompeticaoState extends State<TelaConsultaCompeticao> {
  String textoPesquisa = "";
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar competição"),
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
    ControlCompeticao control = ControlCompeticao();
    List<Competicao> lista = await control.queryFind(_inputPesquisa.text);

    String texto = "";
    for (Competicao c in lista) {
      texto +=
          "${c.id} - ${c.nome} - ${c.cidade} - ${c.dataInicio} - ${c.dataFim}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
