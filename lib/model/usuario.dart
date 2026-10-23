/// Usuario do sistema. O perfil define o que ele pode acessar (RNFR-15.2,
/// RNFR-05.2 e RNFR-16.2).
class Usuario {
  static const String administrador = "ADMIN";
  static const String usuarioComum = "USUARIO";

  final int? id;
  final String login;
  final String senhaHash;
  final String perfil;

  Usuario({
    this.id,
    required this.login,
    required this.senhaHash,
    this.perfil = usuarioComum,
  });

  /// RNFR-15.2 — relatorios financeiros e dados restritos exigem ADMIN
  bool get isAdministrador => perfil == administrador;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'login': login,
      'senha_hash': senhaHash,
      'perfil': perfil,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      login: map['login'],
      senhaHash: map['senha_hash'],
      perfil: map['perfil'] ?? usuarioComum,
    );
  }
}
