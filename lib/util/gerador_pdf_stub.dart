import 'dart:typed_data';

/// Stub usado quando o app roda na web, onde os plugins de PDF nao existem.
class GeradorPdf {
  GeradorPdf();

  Future<Uint8List> relatorioFinanceiro(
    List<Map<String, dynamic>> linhas,
    double total,
  ) async {
    throw UnsupportedError("Exportação em PDF não disponível na web.");
  }

  Future<Uint8List> classificacao(List<Map<String, dynamic>> linhas) async {
    throw UnsupportedError("Exportação em PDF não disponível na web.");
  }

  Future<Uint8List> historicoPartidas(
    List<Map<String, dynamic>> linhas,
  ) async {
    throw UnsupportedError("Exportação em PDF não disponível na web.");
  }

  Future<Uint8List> jogadoresSuspensos(
    List<Map<String, dynamic>> linhas,
  ) async {
    throw UnsupportedError("Exportação em PDF não disponível na web.");
  }

  Future<Uint8List> estatisticasJogador(
    String identificacao,
    List<Map<String, dynamic>> eventos,
    int craques,
    int jogos,
  ) async {
    throw UnsupportedError("Exportação em PDF não disponível na web.");
  }

  Future<String> salvar(Uint8List bytes, String nomeArquivo) async {
    throw UnsupportedError("Exportação em PDF não disponível na web.");
  }

  Future<void> compartilhar(Uint8List bytes, String nomeArquivo) async {
    throw UnsupportedError("Exportação em PDF não disponível na web.");
  }
}
