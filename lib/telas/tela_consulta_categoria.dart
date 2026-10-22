import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_categoria.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaCategoria extends StatefulWidget {
  const TelaConsultaCategoria({super.key});

  @override
  State<TelaConsultaCategoria> createState() => _TelaConsultaCategoriaState();
}

class _TelaConsultaCategoriaState extends State<TelaConsultaCategoria> {
  String textoPesquisa = "";
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar categoria"),
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
    ControlCategoria control = ControlCategoria();
    List<Categoria> lista = await control.queryFind(_inputPesquisa.text);

    String texto = "";
    for (Categoria c in lista) {
      texto += "${c.id} - ${c.nome} (${c.idadeMin} a ${c.idadeMax} anos)\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
