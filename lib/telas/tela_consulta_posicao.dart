import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_posicao.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
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
  List<Map<String, dynamic>> _lista = [];
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
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom(
            textoPesquisa.isEmpty
                ? "Toque em pesquisar para listar as posições."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map((p) => CartaoConsulta(
                p['nome'],
                ["Modalidade: ${p['nomeModalidade']}"],
                icone: Icons.pan_tool,
              )),
      ],
    );
  }

  Future _pesquisar() async {
    ControlPosicao control = ControlPosicao();
    List<Map<String, dynamic>> lista =
        await control.queryFindDetalhado(_inputPesquisa.text);

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhuma posição encontrada." : "";
    });
  }
}
