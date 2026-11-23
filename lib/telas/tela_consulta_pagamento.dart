import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_pagamento.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/telas/tela_adicionar_pagamento.dart';
import 'package:projeto_final/model/pagamento_inscricao.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';
import 'package:projeto_final/util/formatador.dart';

class TelaConsultaPagamento extends StatefulWidget {
  const TelaConsultaPagamento({super.key});

  @override
  State<TelaConsultaPagamento> createState() => _TelaConsultaPagamentoState();
}

class _TelaConsultaPagamentoState extends State<TelaConsultaPagamento> {
  @override
  void initState() {
    super.initState();
    _pesquisar();
    _filtro.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _filtro.dispose();
    super.dispose();
  }
  List<Map<String, dynamic>> _lista = [];
  final _filtro = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar pagamentos"),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => Menu()),
              (_) => false,
            ),
          ),
        ],
      ),
      body: _body(),
    );
  }

  ListView _body() {
    String f = _filtro.text.trim().toLowerCase();
    List<Map<String, dynamic>> filtrados = f.isEmpty
        ? _lista
        : _lista.where((item) => item.values.any((v) => v.toString().toLowerCase().contains(f))).toList();

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos("", "Digite para filtrar", controller: _filtro),
        SizedBox(height: 16),
        if (filtrados.isEmpty)
          TextosCustom("Nenhum resultado", 18, Colors.red)
        else
          ...filtrados.map(_cartao),
      ],
    );
  }

  Widget _cartao(Map<String, dynamic> p) {
    double valor = (p['valorPago'] as num?)?.toDouble() ?? 0;

    return CartaoConsulta(
      p['nomeJogador'] ?? "-",
      [
        "Escola: ${p['nomeEscola'] ?? '-'}",
        "Forma: ${p['formaPagamento']} - Data: ${Formatador.dataBr(p['dataPagamento'])}",
      ],
      selo: "R\$ ${valor.toStringAsFixed(2)}",
      corSelo: Colors.green,
      icone: Icons.payments,
      onTap: () async {
        List<PagamentoInscricao> todos = await ControlPagamento().queryFind();
        PagamentoInscricao? pg;
        try {
          pg = todos.firstWhere((x) => x.id == p['id']);
        } catch (_) {
          pg = null;
        }
        if (pg != null) {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => TelaAdicionarPagamento(pagamento: pg)));
          _pesquisar();
        }
      },
    );
  }

  Future _pesquisar() async {
    try {
    ControlPagamento control = ControlPagamento();
    List<Map<String, dynamic>> lista = await control.queryFindDetalhado();

    setState(() {
      _lista = lista;
    });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
