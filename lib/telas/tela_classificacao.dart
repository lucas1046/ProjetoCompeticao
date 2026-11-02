import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/util/exportacao.dart';
import 'package:projeto_final/util/gerador_pdf.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaClassificacao extends StatefulWidget {
  const TelaClassificacao({super.key});

  @override
  State<TelaClassificacao> createState() => _TelaClassificacaoState();
}

class _TelaClassificacaoState extends State<TelaClassificacao> {
  String _resultado = "";
  String _avisoPdf = "";
  bool _carregando = false;
  bool _exportando = false;
  List<Map<String, dynamic>> _classificacao = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Classificação geral"),
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
        Buttons("Gerar classificação", onPressed: _carregando ? null : () { _gerar(); }),
        SizedBox(height: 12),
        // RNFR-15.1 — exportacao da classificacao em PDF
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
    List<Map<String, dynamic>> lista = await control.classificacaoGeral();

    cronometro.stop();

    setState(() {
      _classificacao = lista;
    });

    String texto = "POS TIME              P   J   V   E   D   GP  GC  SG\n"
        "---------------------------------------------------------\n";

    int posicao = 1;
    for (Map<String, dynamic> item in lista) {
      String nome = (item['nomeTime'] as String).padRight(16);
      int pontos = item['pontos'] ?? 0;
      int jogos = item['jogos'] ?? 0;
      int vitorias = item['vitorias'] ?? 0;
      int empates = item['empates'] ?? 0;
      int derrotas = item['derrotas'] ?? 0;
      int golsPro = item['golsPro'] ?? 0;
      int golsContra = item['golsContra'] ?? 0;
      int saldo = golsPro - golsContra;

      texto += "${posicao.toString().padLeft(3)} $nome "
          "${pontos.toString().padLeft(3)} ${jogos.toString().padLeft(3)} "
          "${vitorias.toString().padLeft(3)} ${empates.toString().padLeft(3)} "
          "${derrotas.toString().padLeft(3)} ${golsPro.toString().padLeft(3)} "
          "${golsContra.toString().padLeft(3)} ${saldo.toString().padLeft(3)}\n";
      posicao++;
    }

    texto += "\nRNFR-15.3 — gerado em ${cronometro.elapsedMilliseconds} ms\n";

    setState(() {
      _resultado = texto;
      _carregando = false;
    });
  }

  // RNFR-15.1 — gera o PDF, salva no dispositivo e abre o compartilhamento
  Future _exportarPdf() async {
    if (_classificacao.isEmpty) {
      setState(() {
        _avisoPdf = "Gere a classificação antes de exportar.";
      });
      return;
    }

    setState(() {
      _exportando = true;
      _avisoPdf = "";
    });

    try {
      String caminho = await Exportacao.exportar(
        gerar: () => GeradorPdf().classificacao(_classificacao),
        nomeArquivo: Exportacao.nomeComData("classificacao"),
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
