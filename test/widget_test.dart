import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:projeto_final/main.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:projeto_final/model/modalidade.dart';
import 'package:projeto_final/model/posicao.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/telas/tela_adicionar_competicao.dart';
import 'package:projeto_final/telas/tela_adicionar_modalidade.dart';

void main() {
  testWidgets('Menu exibe as 5 entidades do cadastro basico',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(Menu), findsOneWidget);
    expect(find.text('Competição'), findsOneWidget);
    expect(find.text('Modalidade'), findsOneWidget);
    expect(find.text('Categoria'), findsOneWidget);
    expect(find.text('Tipo de evento'), findsOneWidget);

    // O GridView e lazy: o ultimo card precisa de scroll para aparecer
    await tester.scrollUntilVisible(
      find.text('Posição'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Posição'), findsOneWidget);
  });

  testWidgets('Navega para o cadastro de competicao',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Cadastrar').first);
    await tester.pumpAndSettle();

    expect(find.byType(TelaAdicionarCompeticao), findsOneWidget);
    expect(find.text('Registrar'), findsOneWidget);
  });

  testWidgets('Navega para o cadastro de modalidade',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Cadastrar').at(1));
    await tester.pumpAndSettle();

    expect(find.byType(TelaAdicionarModalidade), findsOneWidget);
  });

  test('Model Competicao converte para Map e volta', () {
    Competicao c = Competicao(
      id: 1,
      nome: 'Copa Itapetininga',
      cidade: 'Itapetininga',
      dataInicio: '2026-03-01',
      dataFim: '2026-03-15',
    );

    Competicao deVolta = Competicao.fromMap(c.toMap());
    expect(deVolta.nome, c.nome);
    expect(deVolta.cidade, c.cidade);
    expect(deVolta.dataInicio, '2026-03-01');
  });

  test('Model Modalidade converte para Map e volta', () {
    Modalidade m = Modalidade(id: 1, nome: 'Futsal');
    Modalidade deVolta = Modalidade.fromMap(m.toMap());

    expect(deVolta.nome, 'Futsal');
    expect(deVolta.id, 1);
  });

  test('Model Categoria converte para Map e volta', () {
    Categoria c = Categoria(
      id: 1,
      nome: 'Sub-15',
      idadeMin: 12,
      idadeMax: 15,
    );
    Categoria deVolta = Categoria.fromMap(c.toMap());

    expect(deVolta.nome, 'Sub-15');
    expect(deVolta.idadeMin, 12);
    expect(deVolta.idadeMax, 15);
  });

  test('Model TipoEvento converte para Map e volta', () {
    TipoEvento t = TipoEvento(id: 1, descricao: 'Gol');
    TipoEvento deVolta = TipoEvento.fromMap(t.toMap());

    expect(deVolta.descricao, 'Gol');
  });

  test('Model Posicao converte para Map e volta', () {
    Posicao p = Posicao(id: 1, nome: 'Goleiro', idModalidade: 1);
    Posicao deVolta = Posicao.fromMap(p.toMap());

    expect(deVolta.nome, 'Goleiro');
    expect(deVolta.idModalidade, 1);
  });
}
