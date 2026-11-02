import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/telas/tela_detalhe_entidade.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

Widget telaFake(String nome) =>
    Scaffold(body: TextosCustom(nome, 18, Colors.black));

void main() {
  Widget montaDetalhe() {
    return MaterialApp(
      home: TelaDetalheEntidade(
        titulo: "Competição",
        icone: Icons.emoji_events,
        telaCadastro: telaFake("TELA DE CADASTRO"),
        telaConsulta: telaFake("TELA DE CONSULTA"),
      ),
    );
  }

  group('TelaDetalheEntidade', () {
    testWidgets('mostra o titulo e os dois botoes em largura total',
        (tester) async {
      await tester.pumpWidget(montaDetalhe());

      expect(find.text('Competição'), findsWidgets);
      expect(find.widgetWithText(ElevatedButton, 'Cadastrar'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Consultar'), findsOneWidget);
    });

    testWidgets('o cabecalho tem um icone centralizado', (tester) async {
      await tester.pumpWidget(montaDetalhe());

      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('o botao Cadastrar abre a tela de cadastro', (tester) async {
      await tester.pumpWidget(montaDetalhe());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Cadastrar'));
      await tester.pumpAndSettle();

      expect(find.text('TELA DE CADASTRO'), findsOneWidget);
      expect(find.text('TELA DE CONSULTA'), findsNothing);
    });

    testWidgets('o botao Consultar abre a tela de consulta', (tester) async {
      await tester.pumpWidget(montaDetalhe());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Consultar'));
      await tester.pumpAndSettle();

      expect(find.text('TELA DE CONSULTA'), findsOneWidget);
      expect(find.text('TELA DE CADASTRO'), findsNothing);
    });
  });

  group('Menu -> TelaDetalheEntidade', () {
    testWidgets('o card abre a tela de detalhe, nao os botoes direto',
        (tester) async {
      // O GridView monta so o que cabe na tela; tela grande deixa o teste
      // enxergar todos os cards de uma vez
      tester.view.physicalSize = Size(1080, 8000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: Menu()));
      await tester.pumpAndSettle();

      // No menu nao ha mais botoes de Cadastrar/Consultar dentro dos cards
      expect(find.widgetWithText(ElevatedButton, 'Cadastrar'), findsNothing);
      expect(find.widgetWithText(ElevatedButton, 'Consultar'), findsNothing);

      await tester.tap(find.text('Competição'));
      await tester.pumpAndSettle();

      // Depois de tocar no card, a tela de detalhe aparece com os dois botoes
      expect(find.byType(TelaDetalheEntidade), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Cadastrar'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Consultar'), findsOneWidget);
    });
  });
}
