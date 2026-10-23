/// RNFR-15.1 — gera os relatórios em PDF.
/// A implementacao e escolhida em tempo de compilação: no Android/desktop
/// usa a biblioteca pdf + printing; na web (onde esses plugins nao existem)
/// a classe de mesmo nome lanca UnsupportedError.
export 'gerador_pdf_stub.dart' if (dart.library.io) 'gerador_pdf_io.dart';
