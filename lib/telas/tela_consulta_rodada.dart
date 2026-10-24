import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_rodada.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaRodada extends StatefulWidget {
  const TelaConsultaRodada({super.key});

  @override
  State<TelaConsultaRodada> createState() => _TelaConsultaRodadaState();
}

class _TelaConsultaRodadaState extends State<TelaConsultaRodada> {
  String textoPesquisa = "";
  List<Map<String, dynamic>> _lista = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar rodadas"),
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
                ? "Toque em pesquisar para listar as rodadas."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map(_cartao),
      ],
    );
  }

  Widget _cartao(Map<String, dynamic> r) {
    return CartaoConsulta(
      "Rodada ${r['numero']}",
      ["${r['nomeCompeticao']} - Data: ${r['data']}"],
      icone: Icons.calendar_month,
    );
  }

  Future _pesquisar() async {
    ControlRodada control = ControlRodada();
    List<Map<String, dynamic>> lista = await control.queryFindDetalhado();

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhuma rodada encontrada." : "";
    });
  }
}
