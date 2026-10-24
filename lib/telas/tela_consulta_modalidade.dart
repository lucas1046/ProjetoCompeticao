import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_modalidade.dart';
import 'package:projeto_final/model/modalidade.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaModalidade extends StatefulWidget {
  const TelaConsultaModalidade({super.key});

  @override
  State<TelaConsultaModalidade> createState() => _TelaConsultaModalidadeState();
}

class _TelaConsultaModalidadeState extends State<TelaConsultaModalidade> {
  String textoPesquisa = "";
  List<Modalidade> _lista = [];
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar modalidade"),
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
                ? "Toque em pesquisar para listar as modalidades."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map((m) => CartaoConsulta(
                m.nome,
                ["Id: ${m.id}"],
                icone: Icons.sports_soccer,
              )),
      ],
    );
  }

  Future _pesquisar() async {
    ControlModalidade control = ControlModalidade();
    List<Modalidade> lista = await control.queryFind(_inputPesquisa.text);

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhuma modalidade encontrada." : "";
    });
  }
}
