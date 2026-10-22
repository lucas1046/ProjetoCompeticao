class Escola {
  final int? id;
  final String nome;
  final String cidade;
  final String estado;
  final String telefone;
  final int? idFoto;

  Escola({
    this.id,
    required this.nome,
    required this.cidade,
    required this.estado,
    required this.telefone,
    this.idFoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cidade': cidade,
      'estado': estado,
      'telefone': telefone,
      'id_foto': idFoto,
    };
  }

  factory Escola.fromMap(Map<String, dynamic> map) {
    return Escola(
      id: map['id'],
      nome: map['nome'],
      cidade: map['cidade'],
      estado: map['estado'],
      telefone: map['telefone'],
      idFoto: map['id_foto'],
    );
  }
}
