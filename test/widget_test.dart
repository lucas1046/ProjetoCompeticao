import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:projeto_final/main.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/telas/tela_adicionar_competicao.dart';

void main() {
  testWidgets('App abre o Menu com os botoes Cadastrar e Consultar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(Menu), findsOneWidget);
    expect(find.text('Cadastrar'), findsOneWidget);
    expect(find.text('Consultar'), findsOneWidget);
  });

  testWidgets('Botao Cadastrar abre a tela de cadastro',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    expect(find.byType(TelaAdicionarCompeticao), findsOneWidget);
    expect(find.text('Registrar'), findsOneWidget);
  });

  test('Model Competicao converte para Map e volta', () {
    Competicao c = Competicao(
      id: 1,
      nome: 'Copa Itapetininga',
      cidade: 'Itapetininga',
      dataInicio: '2026-03-01',
      dataFim: '2026-03-15',
    );

    Map<String, dynamic> mapa = c.toMap();
    expect(mapa['nome'], 'Copa Itapetininga');
    expect(mapa['data_inicio'], '2026-03-01');

    Competicao deVolta = Competicao.fromMap(mapa);
    expect(deVolta.nome, c.nome);
    expect(deVolta.cidade, c.cidade);
    expect(deVolta.id, c.id);
  });
}
