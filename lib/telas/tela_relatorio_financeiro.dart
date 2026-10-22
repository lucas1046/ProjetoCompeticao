import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaRelatorioFinanceiro extends StatefulWidget {
  const TelaRelatorioFinanceiro({super.key});

  @override
  State<TelaRelatorioFinanceiro> createState() =>
      _TelaRelatorioFinanceiroState();
}

class _TelaRelatorioFinanceiroState extends State<TelaRelatorioFinanceiro> {
  String _resultado = "";
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatório financeiro"),
        backgroundColor: Colors.purple,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Buttons("Gerar relatório", onPressed: _carregando ? null : () { _gerar(); }),
        SizedBox(height: 16),
        if (_carregando) Center(child: CircularProgressIndicator()),
        TextosCustom(_resultado, 16, Colors.black),
      ],
    );
  }

  Future _gerar() async {
    setState(() {
      _carregando = true;
      _resultado = "";
    });

    ControlRelatorio control = ControlRelatorio();
    List<Map<String, dynamic>> lista = await control.situacaoFinanceira();
    double total = await control.totalArrecadado();

    String texto = "JOGADOR              TIME        CAMISA  INSCRIÇÃO  PAGO    SITUAÇÃO\n"
        "-----------------------------------------------------------------------\n";

    for (Map<String, dynamic> item in lista) {
      String nome = (item['nomeJogador'] as String).padRight(18);
      String time = (item['nomeTime'] as String).padRight(10);
      String camisa = (item['numeroCamisa']?.toString() ?? "-").padLeft(4);
      double valorInscricao =
          (item['valorInscricao'] as num?)?.toDouble() ?? 0;
      double valorPago = (item['valorPago'] as num?)?.toDouble() ?? 0;

      String situacao;
      if (valorPago <= 0) {
        situacao = "PENDENTE";
      } else if (valorPago < valorInscricao) {
        situacao = "PARCIAL";
      } else {
        situacao = "PAGO";
      }

      texto +=
          "$nome $time $camisa  ${valorInscricao.toStringAsFixed(2).padLeft(7)}  "
          "${valorPago.toStringAsFixed(2).padLeft(7)}  $situacao\n";
    }

    texto += "\nTOTAL ARRECADADO: R\$ ${total.toStringAsFixed(2)}\n";

    setState(() {
      _resultado = texto;
      _carregando = false;
    });
  }
}
