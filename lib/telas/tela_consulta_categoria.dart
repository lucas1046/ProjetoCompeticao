import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_categoria.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
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
  List<Categoria> _lista = [];
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
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom(
            textoPesquisa.isEmpty
                ? "Toque em pesquisar para listar as categorias."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map((c) => CartaoConsulta(
                c.nome,
                ["Faixa etária: ${c.idadeMin} a ${c.idadeMax} anos"],
                icone: Icons.category,
              )),
      ],
    );
  }

  Future _pesquisar() async {
    ControlCategoria control = ControlCategoria();
    List<Categoria> lista = await control.queryFind(_inputPesquisa.text);

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhuma categoria encontrada." : "";
    });
  }
}
