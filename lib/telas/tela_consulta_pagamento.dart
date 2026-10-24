import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_pagamento.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaPagamento extends StatefulWidget {
  const TelaConsultaPagamento({super.key});

  @override
  State<TelaConsultaPagamento> createState() => _TelaConsultaPagamentoState();
}

class _TelaConsultaPagamentoState extends State<TelaConsultaPagamento> {
  String textoPesquisa = "";
  List<Map<String, dynamic>> _lista = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar pagamentos"),
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
                ? "Toque em pesquisar para listar os pagamentos."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map(_cartao),
      ],
    );
  }

  Widget _cartao(Map<String, dynamic> p) {
    double valor = (p['valorPago'] as num?)?.toDouble() ?? 0;

    return CartaoConsulta(
      p['nomeJogador'] ?? "-",
      [
        "Time: ${p['nomeTime']} - Camisa: ${p['numeroCamisa']}",
        "Forma: ${p['formaPagamento']} - Data: ${p['dataPagamento']}",
      ],
      selo: "R\$ ${valor.toStringAsFixed(2)}",
      corSelo: Colors.green,
      icone: Icons.payments,
    );
  }

  Future _pesquisar() async {
    ControlPagamento control = ControlPagamento();
    List<Map<String, dynamic>> lista = await control.queryFindDetalhado();

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhum pagamento encontrado." : "";
    });
  }
}
