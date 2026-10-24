import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_escalacao.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaEscalacao extends StatefulWidget {
  const TelaConsultaEscalacao({super.key});

  @override
  State<TelaConsultaEscalacao> createState() => _TelaConsultaEscalacaoState();
}

class _TelaConsultaEscalacaoState extends State<TelaConsultaEscalacao> {
  String textoPesquisa = "";
  List<Map<String, dynamic>> _lista = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar escalações"),
        backgroundColor: Colors.orange,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Buttons("Pesquisar", onPressed: _pesquisar),
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom(
            textoPesquisa.isEmpty
                ? "Toque em pesquisar para listar as escalações."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map(_cartao),
      ],
    );
  }

  Widget _cartao(Map<String, dynamic> e) {
    return CartaoConsulta(
      e['nomeJogador'] ?? "-",
      [
        "Time: ${e['nomeTime']}",
        "Camisa: ${e['numeroCamisa']} - ${e['titular']}",
        "Partida: ${e['idPartida']}",
      ],
      icone: Icons.format_list_numbered,
    );
  }

  Future _pesquisar() async {
    ControlEscalacao control = ControlEscalacao();
    List<Map<String, dynamic>> lista = await control.queryFindDetalhado();

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhuma escalação encontrada." : "";
    });
  }
}
