import 'package:projeto_final/util/validacoes.dart';

/// Implementação web: sem acesso ao sistema de arquivos, valida apenas a
/// extensão do caminho informado.
Future<String?> validarImagem(String caminho) async {
  if (!Validacoes.extensaoImagemPermitida(caminho)) {
    return Validacoes.mensagemExtensaoImagem();
  }
  return null;
}
