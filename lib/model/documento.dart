class Documento {
  final int? id;
  final int idJogador;
  final String tipoDocumento;
  final String caminhoArquivo;

  Documento({
    this.id,
    required this.idJogador,
    required this.tipoDocumento,
    required this.caminhoArquivo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_jogador': idJogador,
      'tipo_documento': tipoDocumento,
      'caminho_arquivo': caminhoArquivo,
    };
  }

  factory Documento.fromMap(Map<String, dynamic> map) {
    return Documento(
      id: map['id'],
      idJogador: map['id_jogador'],
      tipoDocumento: map['tipo_documento'],
      caminhoArquivo: map['caminho_arquivo'],
    );
  }
}
