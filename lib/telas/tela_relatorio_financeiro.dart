import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/util/exportacao.dart';
import 'package:projeto_final/util/financeiro.dart';
import 'package:projeto_final/util/gerador_pdf.dart';
import 'package:projeto_final/util/guarda_permissao.dart';
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
  String _avisoPdf = "";
  bool _carregando = false;
  bool _exportando = false;
  List<Map<String, dynamic>> _linhas = [];
  double _total = 0;

  @override
  Widget build(BuildContext context) {
    // RNFR-15.2 — relatório financeiro restrito a administradores
    return GuardaPermissao(
      titulo: "Relatório financeiro",
      motivo: "Este relatório traz os valores das inscrições e dos pagamentos "
          "e só pode ser visto por administradores.",
      child: Scaffold(
        appBar: AppBar(
          title: Text("Relatório financeiro"),
          backgroundColor: Colors.purple,
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
      ),
    );
  }

  ListView _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Buttons("Gerar relatório", onPressed: _carregando ? null : () { _gerar(); }),
        SizedBox(height: 12),
        // RNFR-15.1 — exportacao do relatorio em PDF
        Buttons(
          "Exportar PDF",
          onPressed: _exportando ? null : () { _exportarPdf(); },
        ),
        SizedBox(height: 16),
        if (_carregando || _exportando) Center(child: CircularProgressIndicator()),
        TextosCustom(_resultado, 16, Colors.black),
        if (_avisoPdf.isNotEmpty) TextosCustom(_avisoPdf, 16, Colors.green),
      ],
    );
  }

  Future _gerar() async {
    setState(() {
      _carregando = true;
      _resultado = "";
    });

    // RNFR-15.3 — medicao do tempo de geracao do relatorio
    final cronometro = Stopwatch()..start();

    ControlRelatorio control = ControlRelatorio();
    List<Map<String, dynamic>> lista = await control.situacaoFinanceira();
    double total = await control.totalArrecadado();

    cronometro.stop();

    setState(() {
      _linhas = lista;
      _total = total;
    });

    String texto = "JOGADOR              TIME        CAMISA  INSCRIÇÃO  PAGO    SITUAÇÃO\n"
        "-----------------------------------------------------------------------\n";

    for (Map<String, dynamic> item in lista) {
      String nome = ((item['nomeJogador'] as String?) ?? "-").padRight(18);
      String time = ((item['nomeTime'] as String?) ?? "-").padRight(10);
      String camisa = (item['numeroCamisa']?.toString() ?? "-").padLeft(4);
      double valorInscricao =
          (item['valorInscricao'] as num?)?.toDouble() ?? 0;
      double valorPago = (item['valorPago'] as num?)?.toDouble() ?? 0;

      String situacao = Financeiro.status(valorInscricao, valorPago);

      texto +=
          "$nome $time $camisa  ${valorInscricao.toStringAsFixed(2).padLeft(7)}  "
          "${valorPago.toStringAsFixed(2).padLeft(7)}  $situacao\n";
    }

    texto += "\nTOTAL ARRECADADO: R\$ ${total.toStringAsFixed(2)}\n";
    texto += "\nRNFR-15.3 — gerado em ${cronometro.elapsedMilliseconds} ms\n";

    setState(() {
      _resultado = texto;
      _carregando = false;
    });
  }

  // RNFR-15.1 — gera o PDF, salva no dispositivo e abre o compartilhamento
  Future _exportarPdf() async {
    if (_linhas.isEmpty) {
      setState(() {
        _avisoPdf = "Gere o relatório antes de exportar.";
      });
      return;
    }

    setState(() {
      _exportando = true;
      _avisoPdf = "";
    });

    try {
      String caminho = await Exportacao.exportar(
        gerar: () => GeradorPdf().relatorioFinanceiro(_linhas, _total),
        nomeArquivo: Exportacao.nomeComData("financeiro"),
      );

      setState(() {
        _avisoPdf = "PDF salvo em:\n$caminho";
      });
    } catch (e) {
      setState(() {
        _avisoPdf = "Erro ao exportar: $e";
      });
    } finally {
      setState(() {
        _exportando = false;
      });
    }
  }
}
