import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_participacao.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/model/participacao_jogador_time.dart';
import 'package:projeto_final/util/exportacao.dart';
import 'package:projeto_final/util/gerador_pdf.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaEstatisticasJogador extends StatefulWidget {
  const TelaEstatisticasJogador({super.key});

  @override
  State<TelaEstatisticasJogador> createState() =>
      _TelaEstatisticasJogadorState();
}

class _TelaEstatisticasJogadorState extends State<TelaEstatisticasJogador> {
  String? _idParticipacao;
  List<ParticipacaoJogadorTime> _participacoes = [];
  String _resultado = "";
  String _avisoPdf = "";
  bool _carregando = false;
  bool _exportando = false;

  List<Map<String, dynamic>> _eventos = [];
  int _craques = 0;
  int _jogos = 0;
  String _identificacao = "";

  @override
  void initState() {
    super.initState();
    _carregarParticipacoes();
  }

  Future<void> _carregarParticipacoes() async {
    ControlParticipacao control = ControlParticipacao();
    List<ParticipacaoJogadorTime> lista = await control.queryFind();
    setState(() {
      _participacoes = lista;
      if (lista.isNotEmpty) {
        _idParticipacao = lista[0].id.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Estatísticas do jogador"),
        backgroundColor: Colors.purple,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          value: _idParticipacao,
          decoration: InputDecoration(
            labelText: "Jogador inscrito",
            border: OutlineInputBorder(),
          ),
          items: _participacoes.map((p) {
            return DropdownMenuItem<String>(
              value: p.id.toString(),
              child: Text("Inscrição ${p.id} - camisa ${p.numeroCamisa}"),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idParticipacao = v),
        ),
        SizedBox(height: 16),
        Buttons("Consultar", onPressed: _carregando ? null : () { _consultar(); }),
        SizedBox(height: 12),
        // RNFR-15.1 — exportacao das estatisticas em PDF
        Buttons(
          "Exportar PDF",
          onPressed: _exportando ? null : () { _exportarPdf(); },
        ),
        SizedBox(height: 16),
        if (_carregando || _exportando) Center(child: CircularProgressIndicator()),
        TextosCustom(_resultado, 18, Colors.black),
        if (_avisoPdf.isNotEmpty) TextosCustom(_avisoPdf, 16, Colors.green),
      ],
    );
  }

  Future _consultar() async {
    if (_idParticipacao == null) {
      setState(() {
        _resultado = "Nenhuma inscrição encontrada.";
      });
      return;
    }

    setState(() {
      _carregando = true;
      _resultado = "";
    });

    int idParticipacao = int.parse(_idParticipacao!);

    // RNFR-14.1 — medicao do tempo de processamento das estatisticas
    final cronometro = Stopwatch()..start();

    ControlRelatorio control = ControlRelatorio();

    List<Map<String, dynamic>> eventos =
        await control.estatisticasPorTipo(idParticipacao);
    int craques = await control.totalCraques(idParticipacao);
    int jogos = await control.totalJogos(idParticipacao);

    cronometro.stop();

    setState(() {
      _eventos = eventos;
      _craques = craques;
      _jogos = jogos;
      _identificacao = "Inscrição $idParticipacao";
    });

    String texto = "Jogos participados: $jogos\n"
        "Craque da partida: $craques vez(es)\n\n"
        "Eventos em campo:\n";

    if (eventos.isEmpty) {
      texto += "  Nenhum evento registrado\n";
    } else {
      for (Map<String, dynamic> e in eventos) {
        texto += "  ${e['tipo']}: ${e['total']}\n";
      }
    }

    texto += "\nRNFR-14.1 — processado em ${cronometro.elapsedMilliseconds} ms\n";

    setState(() {
      _resultado = texto;
      _carregando = false;
    });
  }

  // RNFR-15.1 — gera o PDF, salva no dispositivo e abre o compartilhamento
  Future _exportarPdf() async {
    if (_eventos.isEmpty && _jogos == 0) {
      setState(() {
        _avisoPdf = "Consulte as estatísticas antes de exportar.";
      });
      return;
    }

    setState(() {
      _exportando = true;
      _avisoPdf = "";
    });

    try {
      String caminho = await Exportacao.exportar(
        gerar: () => GeradorPdf().estatisticasJogador(
          _identificacao,
          _eventos,
          _craques,
          _jogos,
        ),
        nomeArquivo: Exportacao.nomeComData("estatisticas"),
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
