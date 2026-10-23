import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/model/usuario.dart';
import 'package:projeto_final/util/seguranca.dart';

void main() {
  group('Seguranca (RNFR-15.2 - senhas)', () {
    test('a senha cadastrada confere depois de gerado o hash', () {
      String armazenado = Seguranca.hashSenha('admin123');

      expect(Seguranca.conferirSenha('admin123', armazenado), isTrue);
    });

    test('senha errada nao confere', () {
      String armazenado = Seguranca.hashSenha('admin123');

      expect(Seguranca.conferirSenha('admin124', armazenado), isFalse);
      expect(Seguranca.conferirSenha('', armazenado), isFalse);
    });

    test('o sal aleatorio faz o mesmo hash sair diferente', () {
      String primeiro = Seguranca.hashSenha('segredo');
      String segundo = Seguranca.hashSenha('segredo');

      expect(primeiro, isNot(equals(segundo)));
      expect(Seguranca.conferirSenha('segredo', primeiro), isTrue);
      expect(Seguranca.conferirSenha('segredo', segundo), isTrue);
    });

    test('com o sal informado o hash e deterministico', () {
      String primeiro = Seguranca.hashSenha('segredo', salt: 'salFixo');
      String segundo = Seguranca.hashSenha('segredo', salt: 'salFixo');

      expect(primeiro, equals(segundo));
      expect(Seguranca.conferirSenha('segredo', primeiro), isTrue);
    });

    test('hash sem o formato esperado e recusado', () {
      expect(Seguranca.conferirSenha('segredo', 'texto-sem-sal'), isFalse);
      expect(Seguranca.conferirSenha('segredo', ''), isFalse);
    });

    test('a senha nunca aparece no valor armazenado', () {
      String armazenado = Seguranca.hashSenha('minhaSenhaForte');

      expect(armazenado.contains('minhaSenhaForte'), isFalse);
    });
  });

  group('Usuario (RNFR-15.2 - perfis)', () {
    test('ADMIN tem permissao de administrador', () {
      Usuario admin = Usuario(
        login: 'admin',
        senhaHash: Seguranca.hashSenha('admin123'),
        perfil: Usuario.administrador,
      );

      expect(admin.isAdministrador, isTrue);
    });

    test('usuario comum nao tem permissao de administrador', () {
      Usuario comum = Usuario(
        login: 'joao',
        senhaHash: Seguranca.hashSenha('joao123'),
        perfil: Usuario.usuarioComum,
      );

      expect(comum.isAdministrador, isFalse);
    });

    test('o perfil padrao e USUARIO', () {
      Usuario usuario = Usuario(login: 'maria', senhaHash: 'hash');

      expect(usuario.perfil, equals(Usuario.usuarioComum));
      expect(usuario.isAdministrador, isFalse);
    });

    test('toMap/fromMap preserva login e perfil', () {
      Usuario admin = Usuario(
        id: 1,
        login: 'admin',
        senhaHash: 'sal\$hash',
        perfil: Usuario.administrador,
      );

      Usuario restaurado = Usuario.fromMap(admin.toMap());

      expect(restaurado.login, equals('admin'));
      expect(restaurado.perfil, equals(Usuario.administrador));
      expect(restaurado.senhaHash, equals('sal\$hash'));
      expect(restaurado.isAdministrador, isTrue);
    });
  });
}
