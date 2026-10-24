import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_time.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
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
  List<Map<String, dynamic>> _lista = [];
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
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom(
            textoPesquisa.isEmpty
                ? "Toque em pesquisar para listar os times."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map((t) => CartaoConsulta(
                t['nomeTime'],
                [
                  "Escola: ${t['nomeEscola']}",
                  "Modalidade: ${t['nomeModalidade']}  -  "
                      "Categoria: ${t['nomeCategoria']}",
                ],
                icone: Icons.groups,
              )),
      ],
    );
  }

  Future _pesquisar() async {
    ControlTime control = ControlTime();
    List<Map<String, dynamic>> lista =
        await control.queryFindDetalhado(_inputPesquisa.text);

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhum time encontrado." : "";
    });
  }
}
