import 'dart:io';

import 'package:projeto_final/util/validacoes.dart';

/// Implementação mobile/desktop: valida a extensão e o tamanho real do
/// arquivo (RNFR-03.2 — no máximo 5 MB).
Future<String?> validarImagem(String caminho) async {
  if (caminho.trim().isEmpty) {
    return "Informe o caminho da imagem.";
  }

  if (!Validacoes.extensaoImagemPermitida(caminho)) {
    return Validacoes.mensagemExtensaoImagem();
  }

  // O tamanho só é verificado se o arquivo existir no caminho informado.
  final File arquivo = File(caminho.trim());
  if (!arquivo.existsSync()) {
    return null;
  }

  final int tamanho = await arquivo.length();
  if (tamanho > Validacoes.tamanhoMaximoImagem) {
    double megabytes = tamanho / (1024 * 1024);
    return "A imagem tem ${megabytes.toStringAsFixed(1)} MB, "
        "mas o máximo permitido é 5 MB.";
  }

  return null;
}
