/// RNFR-03.2 — valida o arquivo de imagem informado.
/// Retorna null quando a imagem é válida ou a mensagem do que impede
/// o cadastro. Implementação escolhida em tempo de compilação: no Android/
/// desktop usa dart:io para checar o tamanho real do arquivo; na web faz
/// apenas a validação de extensão (sem acesso ao sistema de arquivos).
export 'validacao_arquivo_stub.dart'
    if (dart.library.io) 'validacao_arquivo_io.dart'
    show validarImagem;
