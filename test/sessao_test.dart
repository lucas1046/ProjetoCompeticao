import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/control/control_sessao.dart';
import 'package:projeto_final/model/usuario.dart';
import 'package:projeto_final/telas/tela_login.dart';

void main() {
  group('ControlSessao (RNFR-15.2)', () {
    setUp(() => ControlSessao().sair());

    test('comeca deslogado', () {
      expect(ControlSessao().logado, isFalse);
      expect(ControlSessao().usuario, isNull);
      expect(ControlSessao().isAdministrador, isFalse);
    });

    test('entrar() registra o usuario da sessao', () {
      ControlSessao().entrar(
        Usuario(login: 'admin', senhaHash: 'x', perfil: Usuario.administrador),
      );

      expect(ControlSessao().logado, isTrue);
      expect(ControlSessao().usuario?.login, equals('admin'));
      expect(ControlSessao().isAdministrador, isTrue);
    });

    test('sair() encerra a sessao', () {
      ControlSessao().entrar(
        Usuario(login: 'admin', senhaHash: 'x', perfil: Usuario.administrador),
      );
      expect(ControlSessao().logado, isTrue);

      ControlSessao().sair();

      expect(ControlSessao().logado, isFalse);
      expect(ControlSessao().isAdministrador, isFalse);
    });

    test('usuario comum nao vira administrador na sessao', () {
      ControlSessao().entrar(
        Usuario(login: 'joao', senhaHash: 'x', perfil: Usuario.usuarioComum),
      );

      expect(ControlSessao().logado, isTrue);
      expect(ControlSessao().isAdministrador, isFalse);
    });
  });

  group('TelaLogin (RNFR-15.2)', () {
    testWidgets('mostra os campos de login e senha', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: TelaLogin()),
      );

      expect(find.text('Acesso ao sistema'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('o campo de senha esconde o que foi digitado', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: TelaLogin()),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Senha'),
        'admin123',
      );
      await tester.pump();

      EditableText texto = tester.widget<EditableText>(
        find.descendant(
          of: find.widgetWithText(TextFormField, 'Senha'),
          matching: find.byType(EditableText),
        ),
      );
      expect(texto.obscureText, isTrue);
    });
  });
}
