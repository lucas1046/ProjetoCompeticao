import 'dart:typed_data';

import 'package:projeto_final/util/gerador_pdf.dart';

/// RNFR-15.1 — auxilia a exportacao dos relatorios em PDF.
class Exportacao {
  /// Gera o PDF, grava no dispositivo e abre a folha de compartilhamento.
  /// Devolve o caminho do arquivo gerado.
  static Future<String> exportar({
    required Future<Uint8List> Function() gerar,
    required String nomeArquivo,
  }) async {
    GeradorPdf gerador = GeradorPdf();

    Uint8List bytes = await gerar();
    String caminho = await gerador.salvar(bytes, nomeArquivo);

    try {
      await gerador.compartilhar(bytes, nomeArquivo);
    } catch (_) {
      // A folha de compartilhamento pode nao existir em alguns dispositivos;
      // o arquivo continua salvo no caminho devolvido.
    }

    return caminho;
  }

  /// Monta um nome de arquivo com a data e hora, ex: relatorio_20261023_1530.pdf
  static String nomeComData(String prefixo) {
    DateTime agora = DateTime.now();
    String d(int n) => n.toString().padLeft(2, "0");
    return "${prefixo}_${agora.year}${d(agora.month)}${d(agora.day)}_"
        "${d(agora.hour)}${d(agora.minute)}${d(agora.second)}.pdf";
  }
}
