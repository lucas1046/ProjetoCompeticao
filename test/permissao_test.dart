import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/control/control_sessao.dart';
import 'package:projeto_final/model/usuario.dart';
import 'package:projeto_final/telas/tela_consulta_documento.dart';
import 'package:projeto_final/telas/tela_consulta_responsavel.dart';
import 'package:projeto_final/telas/tela_relatorio_financeiro.dart';
import 'package:projeto_final/util/guarda_permissao.dart';

Widget _monta(Widget tela) => MaterialApp(home: tela);

void main() {
  setUp(() => ControlSessao().sair());

  group('GuardaPermissao (RNFR-15.2, RNFR-05.2 e RNFR-16.2)', () {
    testWidgets('sem sessao mostra o aviso de acesso restrito', (tester) async {
      await tester.pumpWidget(_monta(GuardaPermissao(
        titulo: "Área restrita",
        motivo: "Conteúdo sensível.",
        child: const Text("CONTEUDO SENSIVEL"),
      )));

      expect(find.text("Acesso restrito"), findsOneWidget);
      expect(find.text("CONTEUDO SENSIVEL"), findsNothing);
    });

    testWidgets('com administrador mostra o conteudo', (tester) async {
      ControlSessao().entrar(Usuario(
        login: 'admin',
        senhaHash: 'x',
        perfil: Usuario.administrador,
      ));

      await tester.pumpWidget(_monta(GuardaPermissao(
        titulo: "Área restrita",
        motivo: "Conteúdo sensível.",
        child: const Text("CONTEUDO SENSIVEL"),
      )));

      expect(find.text("CONTEUDO SENSIVEL"), findsOneWidget);
      expect(find.text("Acesso restrito"), findsNothing);
    });

    testWidgets('com usuario comum mostra o aviso', (tester) async {
      ControlSessao().entrar(Usuario(
        login: 'joao',
        senhaHash: 'x',
        perfil: Usuario.usuarioComum,
      ));

      await tester.pumpWidget(_monta(GuardaPermissao(
        titulo: "Área restrita",
        motivo: "Conteúdo sensível.",
        child: const Text("CONTEUDO SENSIVEL"),
      )));

      expect(find.text("Acesso restrito"), findsOneWidget);
      expect(find.text("CONTEUDO SENSIVEL"), findsNothing);
    });
  });

  group('Telas protegidas', () {
    testWidgets('relatório financeiro bloqueado sem administrador',
        (tester) async {
      await tester.pumpWidget(_monta(TelaRelatorioFinanceiro()));

      expect(find.text("Acesso restrito"), findsOneWidget);
      expect(find.text("Gerar relatório"), findsNothing);
    });

    testWidgets('relatório financeiro liberado para administrador',
        (tester) async {
      ControlSessao().entrar(Usuario(
        login: 'admin',
        senhaHash: 'x',
        perfil: Usuario.administrador,
      ));

      await tester.pumpWidget(_monta(TelaRelatorioFinanceiro()));

      expect(find.text("Acesso restrito"), findsNothing);
      expect(find.text("Gerar relatório"), findsOneWidget);
    });

    testWidgets('consulta de documento bloqueada sem administrador',
        (tester) async {
      await tester.pumpWidget(_monta(TelaConsultaDocumento()));

      expect(find.text("Acesso restrito"), findsOneWidget);
      expect(find.text("Consultar documento"), findsOneWidget);
    });

    testWidgets('consulta de responsável bloqueada sem administrador',
        (tester) async {
      await tester.pumpWidget(_monta(TelaConsultaResponsavel()));

      expect(find.text("Acesso restrito"), findsOneWidget);
    });
  });
}
