import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:projeto_final/util/financeiro.dart';
import 'package:projeto_final/util/formatador.dart';

/// RNFR-15.1 — gera os relatórios do sistema em PDF e permite salvar ou
/// compartilhar o arquivo gerado.
class GeradorPdf {
  static const PdfColor _corTitulo = PdfColor.fromInt(0xFF1565C0);
  static const PdfColor _corCabecalho = PdfColor.fromInt(0xFFE3F2FD);

  static const String _fonteRegular = 'assets/fonts/roboto-regular.ttf';
  static const String _fonteNegrito = 'assets/fonts/roboto-bold.ttf';

  // A Helvetica (fonte padrao do pacote pdf) nao tem suporte a acentos, e
  // por isso os textos do sistema nao poderiam ser escritos com a Roboto.
  static pw.Font? _fonteBase;
  static pw.Font? _fonteBold;

  GeradorPdf();

  /// Carrega as fontes uma unica vez
  static Future<void> _carregarFontes() async {
    if (_fonteBase != null && _fonteBold != null) {
      return;
    }

    ByteData regular = await rootBundle.load(_fonteRegular);
    ByteData negrito = await rootBundle.load(_fonteNegrito);

    _fonteBase = pw.Font.ttf(regular);
    _fonteBold = pw.Font.ttf(negrito);
  }

  // ---------------------------------------------------------
  // RELATORIOS
  // ---------------------------------------------------------

  /// Relatório financeiro com o status de cada inscrição (RNFR-13.3)
  Future<Uint8List> relatorioFinanceiro(
    List<Map<String, dynamic>> linhas,
    double total,
  ) async {
    List<List<String>> dados = [];

    for (Map<String, dynamic> item in linhas) {
      double valorInscricao =
          (item['valorInscricao'] as num?)?.toDouble() ?? 0;
      double valorPago = (item['valorPago'] as num?)?.toDouble() ?? 0;
      String status = Financeiro.status(valorInscricao, valorPago);

      dados.add([
        item['nomeJogador'] ?? "-",
        item['nomeTime'] ?? "-",
        item['numeroCamisa']?.toString() ?? "-",
        valorInscricao.toStringAsFixed(2),
        valorPago.toStringAsFixed(2),
        status,
      ]);
    }

    return _montarPdf(
      titulo: "Relatório financeiro",
      colunas: ["JOGADOR", "TIME", "CAMISA", "INSCRIÇÃO", "PAGO", "SITUAÇÃO"],
      linhas: dados,
      rodape: "Total arrecadado: R\$ ${total.toStringAsFixed(2)}",
    );
  }

  /// Classificação geral do campeonato
  Future<Uint8List> classificacao(List<Map<String, dynamic>> linhas) async {
    List<List<String>> dados = [];
    int posicao = 1;

    for (Map<String, dynamic> item in linhas) {
      int golsPro = (item['golsPro'] as num?)?.toInt() ?? 0;
      int golsContra = (item['golsContra'] as num?)?.toInt() ?? 0;

      dados.add([
        posicao.toString(),
        item['nomeTime'] ?? "-",
        (item['pontos'] ?? 0).toString(),
        (item['jogos'] ?? 0).toString(),
        (item['vitorias'] ?? 0).toString(),
        (item['empates'] ?? 0).toString(),
        (item['derrotas'] ?? 0).toString(),
        golsPro.toString(),
        golsContra.toString(),
        (golsPro - golsContra).toString(),
      ]);
      posicao++;
    }

    return _montarPdf(
      titulo: "Classificação geral",
      colunas: ["POS", "TIME", "P", "J", "V", "E", "D", "GP", "GC", "SG"],
      linhas: dados,
    );
  }

  /// Histórico de partidas
  Future<Uint8List> historicoPartidas(
    List<Map<String, dynamic>> linhas,
  ) async {
    List<List<String>> dados = [];

    for (Map<String, dynamic> item in linhas) {
      int golsCasa = (item['golsCasa'] as num?)?.toInt() ?? 0;
      int golsVisitante = (item['golsVisitante'] as num?)?.toInt() ?? 0;
      bool wo = item['wo'] == 1;

      dados.add([
        item['nomeCompeticao'] ?? "-",
        (item['numeroRodada'] ?? "-").toString(),
        item['timeCasa'] ?? "-",
        "$golsCasa x $golsVisitante${wo ? ' (WO)' : ''}",
        item['timeVisitante'] ?? "-",
      ]);
    }

    return _montarPdf(
      titulo: "Histórico de partidas",
      colunas: ["COMPETIÇÃO", "ROD", "TIME CASA", "RESULTADO", "VISITANTE"],
      linhas: dados,
    );
  }

  /// Jogadores suspensos
  Future<Uint8List> jogadoresSuspensos(
    List<Map<String, dynamic>> linhas,
  ) async {
    List<List<String>> dados = [];

    for (Map<String, dynamic> item in linhas) {
      dados.add([
        item['nomeJogador'] ?? "-",
        item['nomeTime'] ?? "-",
        item['motivo'] ?? "-",
        (item['qtdJogos'] ?? 0).toString(),
        item['tipoEvento'] ?? "-",
        (item['minuto'] ?? "-").toString(),
      ]);
    }

    return _montarPdf(
      titulo: "Jogadores suspensos",
      colunas: ["JOGADOR", "TIME", "MOTIVO", "JOGOS", "EVENTO", "MIN"],
      linhas: dados,
    );
  }

  /// Estatísticas de um jogador escalado
  Future<Uint8List> estatisticasJogador(
    String identificacao,
    List<Map<String, dynamic>> eventos,
    int craques,
    int jogos,
  ) async {
    List<List<String>> dados = [];

    for (Map<String, dynamic> item in eventos) {
      dados.add([item['tipo'] ?? "-", (item['total'] ?? 0).toString()]);
    }

    if (dados.isEmpty) {
      dados.add(["Nenhum evento registrado", "0"]);
    }

    return _montarPdf(
      titulo: "Estatísticas do jogador - $identificacao",
      colunas: ["EVENTO", "QUANTIDADE"],
      linhas: dados,
      rodape: "Jogos participados: $jogos\nCraque da partida: $craques vez(es)",
    );
  }

  /// Ficha de inscrição individual do jogador (RNFR-06.x)
  Future<Uint8List> fichaJogador(
    Map<String, dynamic> jogador,
    List<Map<String, dynamic>> participacoes,
    Map<int, List<Map<String, dynamic>>> pagamentos,
  ) async {
    await _carregarFontes();

    pw.Document documento = pw.Document(
      theme: pw.ThemeData.withFont(base: _fonteBase!, bold: _fonteBold!),
    );

    List<pw.Widget> conteudo = [];

    conteudo.add(_cabecalho("Ficha de inscrição do jogador"));
    conteudo.add(pw.SizedBox(height: 8));

    // Dados do jogador
    conteudo.add(pw.Text("Dados do jogador",
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)));
    conteudo.add(pw.SizedBox(height: 4));
    conteudo.add(_linha("Nome", jogador['nome']?.toString() ?? "-"));
    conteudo.add(_linha("CPF", jogador['cpf']?.toString() ?? "-"));
    conteudo.add(_linha("Data de nascimento",
        Formatador.dataBr(jogador['data_nascimento']?.toString() ?? "-")));
    conteudo.add(_linha("Responsável", jogador['nomeResponsavel']?.toString() ?? "-"));
    conteudo.add(pw.SizedBox(height: 12));

    // Participações
    conteudo.add(pw.Text("Inscrições em times",
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)));
    conteudo.add(pw.SizedBox(height: 4));

    if (participacoes.isEmpty) {
      conteudo.add(pw.Text("Nenhuma inscrição registrada.",
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)));
    } else {
      for (var p in participacoes) {
        int id = p['id'] as int;
        List pgs = pagamentos[id] ?? [];
        double pago = pgs.fold(0.0, (s, pg) => s + ((pg['valor_pago'] as num?)?.toDouble() ?? 0));
        double insc = (p['valor_inscricao'] as num?)?.toDouble() ?? 0;

        conteudo.add(pw.Container(
          margin: pw.EdgeInsets.only(bottom: 8),
          padding: pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(p['nome_time']?.toString() ?? "-",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text("Escola: ${p['nomeEscola'] ?? '-'}", style: pw.TextStyle(fontSize: 10)),
              pw.Text("Número da camisa: ${p['numero_camisa'] ?? '-'}", style: pw.TextStyle(fontSize: 10)),
              pw.Text("Inscrição: R\$ ${insc.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10)),
              pw.Text("Pago: R\$ ${pago.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10)),
            ],
          ),
        ));
      }
    }

    conteudo.add(pw.SizedBox(height: 12));
    conteudo.add(pw.Text("Assinatura do responsável: ______________________________",
        style: pw.TextStyle(fontSize: 10)));
    conteudo.add(pw.SizedBox(height: 4));
    conteudo.add(pw.Text("Data: ___/___/______", style: pw.TextStyle(fontSize: 10)));

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => conteudo,
      ),
    );

    return documento.save();
  }

  pw.Widget _linha(String rotulo, String valor) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        children: [
          pw.Text("$rotulo: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          pw.Text(valor, style: pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // SALVAR E COMPARTILHAR
  // ---------------------------------------------------------

  /// Grava o PDF no diretório de documentos do app e devolve o caminho
  Future<String> salvar(Uint8List bytes, String nomeArquivo) async {
    Directory diretorio = await getApplicationDocumentsDirectory();
    String caminho = "${diretorio.path}/$nomeArquivo";
    File arquivo = File(caminho);
    await arquivo.writeAsBytes(bytes);
    return caminho;
  }

  /// Abre a folha de compartilhamento do sistema com o PDF
  Future<void> compartilhar(Uint8List bytes, String nomeArquivo) async {
    await Printing.sharePdf(bytes: bytes, filename: nomeArquivo);
  }

  // ---------------------------------------------------------
  // MONTAGEM DO DOCUMENTO
  // ---------------------------------------------------------

  Future<Uint8List> _montarPdf({
    required String titulo,
    required List<String> colunas,
    required List<List<String>> linhas,
    String rodape = "",
  }) async {
    await _carregarFontes();

    pw.Document documento = pw.Document(
      theme: pw.ThemeData.withFont(base: _fonteBase!, bold: _fonteBold!),
    );

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          Map<int, pw.AlignmentGeometry> alinhamentos = {
            for (int i = 0; i < colunas.length; i++) i: pw.Alignment.center,
          };

          return [
            _cabecalho(titulo),
            pw.TableHelper.fromTextArray(
              headers: colunas,
              data: linhas,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: pw.BoxDecoration(color: _corTitulo),
              headerAlignments: alinhamentos,
              cellAlignments: alinhamentos,
              oddRowDecoration: pw.BoxDecoration(color: _corCabecalho),
              border: pw.TableBorder.all(color: PdfColors.grey400),
            ),
            if (rodape.isNotEmpty) ...[
              pw.SizedBox(height: 12),
              pw.Text(
                rodape,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ];
        },
      ),
    );

    return documento.save();
  }

  pw.Widget _cabecalho(String titulo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Competições Escolares",
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: _corTitulo,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          titulo,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text("Gerado em ${_dataHora()}"),
        pw.Divider(),
        pw.SizedBox(height: 8),
      ],
    );
  }

  String _dataHora() {
    DateTime agora = DateTime.now();
    String dois(int n) => n.toString().padLeft(2, "0");
    return "${dois(agora.day)}/${dois(agora.month)}/${agora.year} "
        "${dois(agora.hour)}:${dois(agora.minute)}";
  }
}
