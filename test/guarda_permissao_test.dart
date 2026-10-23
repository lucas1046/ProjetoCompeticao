import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/control/control_sessao.dart';
import 'package:projeto_final/model/usuario.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/util/guarda_permissao.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

Usuario admin = Usuario(
  login: 'admin',
  senhaHash: 'x',
  perfil: Usuario.administrador,
);

Usuario comum = Usuario(
  login: 'joao',
  senhaHash: 'x',
  perfil: Usuario.usuarioComum,
);

Widget conteudoDeTeste = Scaffold(
  body: TextosCustom("CONTEUDO SECRETO", 18, Colors.black),
);

void main() {
  setUp(() => ControlSessao().sair());
  tearDown(() => ControlSessao().sair());

  group('GuardaPermissao (RNFR-15.2, RNFR-05.2 e RNFR-16.2)', () {
    testWidgets('administrador ve o conteudo da tela', (tester) async {
      ControlSessao().entrar(admin);

      await tester.pumpWidget(MaterialApp(
        home: GuardaPermissao(
          titulo: "Tela restrita",
          motivo: "motivo qualquer",
          child: conteudoDeTeste,
        ),
      ));

      expect(find.text('CONTEUDO SECRETO'), findsOneWidget);
      expect(find.text('Acesso restrito'), findsNothing);
    });

    testWidgets('usuario comum ve o aviso em vez do conteudo', (tester) async {
      ControlSessao().entrar(comum);

      await tester.pumpWidget(MaterialApp(
        home: GuardaPermissao(
          titulo: "Tela restrita",
          motivo: "motivo qualquer",
          child: conteudoDeTeste,
        ),
      ));

      expect(find.text('CONTEUDO SECRETO'), findsNothing);
      expect(find.text('Acesso restrito'), findsOneWidget);
      expect(find.text('motivo qualquer'), findsOneWidget);
    });

    testWidgets('sem sessao o conteudo tambem fica bloqueado', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: GuardaPermissao(
          titulo: "Tela restrita",
          motivo: "motivo qualquer",
          child: conteudoDeTeste,
        ),
      ));

      expect(find.text('CONTEUDO SECRETO'), findsNothing);
      expect(find.text('Acesso restrito'), findsOneWidget);
    });

    testWidgets('o aviso mostra o perfil da sessao', (tester) async {
      ControlSessao().entrar(comum);

      await tester.pumpWidget(MaterialApp(
        home: GuardaPermissao(
          titulo: "Tela restrita",
          motivo: "motivo qualquer",
          child: conteudoDeTeste,
        ),
      ));

      expect(
        find.text('Perfil da sessão: ${Usuario.usuarioComum}'),
        findsOneWidget,
      );
    });
  });

  group('Menu (RNFR-15.2, RNFR-05.2 e RNFR-16.2)', () {
    // O GridView monta so os cards que cabem na tela; um celular grande
    // o bastante para ver todos de uma vez deixa o teste determinístico
    void telaGrande(WidgetTester tester) {
      tester.view.physicalSize = Size(1080, 8000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
    }

    testWidgets('usuario comum nao ve Documento nem Responsavel',
        (tester) async {
      telaGrande(tester);
      ControlSessao().entrar(comum);

      await tester.pumpWidget(MaterialApp(home: Menu()));
      await tester.pumpAndSettle();

      expect(find.text('Documento'), findsNothing);
      expect(find.text('Responsável'), findsNothing);
      // o resto do menu continua visivel
      expect(find.text('Jogador'), findsOneWidget);
      expect(find.text('Escola'), findsOneWidget);
    });

    testWidgets('administrador ve Documento e Responsavel', (tester) async {
      telaGrande(tester);
      ControlSessao().entrar(admin);

      await tester.pumpWidget(MaterialApp(home: Menu()));
      await tester.pumpAndSettle();

      expect(find.text('Documento'), findsOneWidget);
      expect(find.text('Responsável'), findsOneWidget);
    });
  });
}
