import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/util/exportacao.dart';
import 'package:projeto_final/util/gerador_pdf.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaRelatorioPartidas extends StatefulWidget {
  const TelaRelatorioPartidas({super.key});

  @override
  State<TelaRelatorioPartidas> createState() => _TelaRelatorioPartidasState();
}

class _TelaRelatorioPartidasState extends State<TelaRelatorioPartidas> {
  String _resultado = "";
  String _avisoPdf = "";
  bool _carregando = false;
  bool _exportando = false;
  List<Map<String, dynamic>> _partidas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico de partidas"),
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
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Buttons("Gerar relatório", onPressed: _carregando ? null : () { _gerar(); }),
        SizedBox(height: 12),
        // RNFR-15.1 — exportacao do historico em PDF
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
    List<Map<String, dynamic>> lista = await control.historicoPartidas();

    cronometro.stop();

    setState(() {
      _partidas = lista;
    });

    String texto = "COMPETIÇÃO           ROD  CASA              X  VISITANTE\n"
        "--------------------------------------------------------------\n";

    for (Map<String, dynamic> p in lista) {
      String competicao = (p['nomeCompeticao'] as String).padRight(18);
      String rodada = (p['numeroRodada']?.toString() ?? "-").padLeft(3);
      String casa = (p['timeCasa'] as String).padRight(16);
      String visitante = p['timeVisitante'] as String;
      int golsCasa = p['golsCasa'] as int? ?? 0;
      int golsVisitante = p['golsVisitante'] as int? ?? 0;
      bool wo = p['wo'] == 1;

      texto += "$competicao $rodada  $casa $golsCasa x $golsVisitante $visitante";
      if (wo) {
        texto += "  (WO)";
      }
      texto += "\n";
    }

    if (lista.isEmpty) {
      texto += "Nenhuma partida registrada ainda.\n";
    }

    texto += "\nRNFR-15.3 — gerado em ${cronometro.elapsedMilliseconds} ms\n";

    setState(() {
      _resultado = texto;
      _carregando = false;
    });
  }

  // RNFR-15.1 — gera o PDF, salva no dispositivo e abre o compartilhamento
  Future _exportarPdf() async {
    if (_partidas.isEmpty) {
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
        gerar: () => GeradorPdf().historicoPartidas(_partidas),
        nomeArquivo: Exportacao.nomeComData("partidas"),
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
