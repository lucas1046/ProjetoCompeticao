import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/util/exportacao.dart';
import 'package:projeto_final/util/gerador_pdf.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaRelatorioSuspensos extends StatefulWidget {
  const TelaRelatorioSuspensos({super.key});

  @override
  State<TelaRelatorioSuspensos> createState() => _TelaRelatorioSuspensosState();
}

class _TelaRelatorioSuspensosState extends State<TelaRelatorioSuspensos> {
  String _resultado = "";
  String _avisoPdf = "";
  bool _carregando = false;
  bool _exportando = false;
  List<Map<String, dynamic>> _suspensos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jogadores suspensos"),
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
    List<Map<String, dynamic>> lista = await control.jogadoresSuspensos();

    cronometro.stop();

    setState(() {
      _suspensos = lista;
    });

    String texto = "JOGADOR              TIME        MOTIVO               JOGOS\n"
        "--------------------------------------------------------------\n";

    for (Map<String, dynamic> s in lista) {
      String nome = (s['nomeJogador'] as String).padRight(18);
      String time = (s['nomeTime'] as String).padRight(10);
      String motivo = (s['motivo'] as String).padRight(20);
      int jogos = s['qtdJogos'] as int? ?? 0;

      texto += "$nome $time $motivo ${jogos.toString().padLeft(4)}\n";
    }

    if (lista.isEmpty) {
      texto += "Nenhum jogador suspenso no momento.\n";
    }

    texto += "\nRNFR-15.3 — gerado em ${cronometro.elapsedMilliseconds} ms\n";

    setState(() {
      _resultado = texto;
      _carregando = false;
    });
  }

  // RNFR-15.1 — gera o PDF, salva no dispositivo e abre o compartilhamento
  Future _exportarPdf() async {
    if (_suspensos.isEmpty) {
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
        gerar: () => GeradorPdf().jogadoresSuspensos(_suspensos),
        nomeArquivo: Exportacao.nomeComData("suspensos"),
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
