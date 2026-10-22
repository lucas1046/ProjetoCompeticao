class FotoFigurinha {
  final int? id;
  final String caminhoArquivo;
  final String dataUpload;

  FotoFigurinha({
    this.id,
    required this.caminhoArquivo,
    required this.dataUpload,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caminho_arquivo': caminhoArquivo,
      'data_upload': dataUpload,
    };
  }

  factory FotoFigurinha.fromMap(Map<String, dynamic> map) {
    return FotoFigurinha(
      id: map['id'],
      caminhoArquivo: map['caminho_arquivo'],
      dataUpload: map['data_upload'],
    );
  }
}
