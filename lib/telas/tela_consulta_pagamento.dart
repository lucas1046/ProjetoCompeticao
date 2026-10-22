import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_pagamento.dart';
import 'package:projeto_final/model/pagamento_inscricao.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaPagamento extends StatefulWidget {
  const TelaConsultaPagamento({super.key});

  @override
  State<TelaConsultaPagamento> createState() => _TelaConsultaPagamentoState();
}

class _TelaConsultaPagamentoState extends State<TelaConsultaPagamento> {
  String textoPesquisa = "";

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
        TextosCustom(textoPesquisa, 18, Colors.red),
      ],
    );
  }

  Future _pesquisar() async {
    ControlPagamento control = ControlPagamento();
    List<PagamentoInscricao> lista = await control.queryFind();

    String texto = "";
    for (PagamentoInscricao p in lista) {
      texto +=
          "${p.id} - R\$ ${p.valorPago} - ${p.formaPagamento} - ${p.dataPagamento}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
