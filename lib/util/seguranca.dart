import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// RNFR-15.2 — tratamento das senhas dos usuarios.
/// A senha nunca é gravada em texto puro: usa SHA-256 com um "sal"
/// aleatório, e o sal viaja junto com o hash no formato "sal$hash".
class Seguranca {
  static String _gerarSalt([int tamanho = 16]) {
    final Random aleatorio = Random.secure();
    final List<int> bytes = List<int>.generate(
      tamanho,
      (_) => aleatorio.nextInt(256),
    );
    return base64Encode(bytes);
  }

  /// Gera o hash da senha. Se o sal for informado, reutiliza o mesmo
  /// (necessario para conferir uma senha ja cadastrada).
  static String hashSenha(String senha, {String? salt}) {
    String salUsado = salt ?? _gerarSalt();
    String hash = sha256.convert(utf8.encode('$salUsado$senha')).toString();
    return '$salUsado\$$hash';
  }

  /// Verifica se a senha informada confere com o hash armazenado
  static bool conferirSenha(String senha, String armazenado) {
    List<String> partes = armazenado.split('\$');
    if (partes.length != 2) {
      return false;
    }
    return hashSenha(senha, salt: partes[0]) == armazenado;
  }
}
