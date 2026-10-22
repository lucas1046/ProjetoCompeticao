class Responsavel {
  final int? id;
  final String nome;
  final String cpf;
  final String telefone;
  final String email;
  final String parentesco;

  Responsavel({
    this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.email,
    required this.parentesco,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'email': email,
      'parentesco': parentesco,
    };
  }

  factory Responsavel.fromMap(Map<String, dynamic> map) {
    return Responsavel(
      id: map['id'],
      nome: map['nome'],
      cpf: map['cpf'],
      telefone: map['telefone'],
      email: map['email'],
      parentesco: map['parentesco'],
    );
  }
}
