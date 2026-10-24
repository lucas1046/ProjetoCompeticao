import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_evento.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaEvento extends StatefulWidget {
  const TelaConsultaEvento({super.key});

  @override
  State<TelaConsultaEvento> createState() => _TelaConsultaEventoState();
}

class _TelaConsultaEventoState extends State<TelaConsultaEvento> {
  String textoPesquisa = "";
  List<Map<String, dynamic>> _lista = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar eventos"),
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
                ? "Toque em pesquisar para listar os eventos."
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
    List<String> linhas = [
      "Jogador: ${e['nomeJogador']} - ${e['nomeTime']}",
      "Minuto: ${e['minuto']}",
    ];

    if (e['descricao'] != null && (e['descricao'] as String).isNotEmpty) {
      linhas.add(e['descricao']);
    }

    return CartaoConsulta(
      e['tipoEvento'] ?? "-",
      linhas,
      icone: Icons.timer,
    );
  }

  Future _pesquisar() async {
    ControlEvento control = ControlEvento();
    List<Map<String, dynamic>> lista = await control.queryFindDetalhado();

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhum evento encontrado." : "";
    });
  }
}
