import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/util/exportacao.dart';
import 'package:projeto_final/util/gerador_pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Dados de exemplo com o mesmo formato que o ControlRelatorio devolve
  final List<Map<String, dynamic>> classificacao = [
    {
      'nomeTime': 'Time A',
      'pontos': 9,
      'jogos': 4,
      'vitorias': 3,
      'empates': 0,
      'derrotas': 1,
      'golsPro': 12,
      'golsContra': 5,
    },
    {
      'nomeTime': 'Time B',
      'pontos': 4,
      'jogos': 4,
      'vitorias': 1,
      'empates': 1,
      'derrotas': 2,
      'golsPro': 6,
      'golsContra': 8,
    },
  ];

  final List<Map<String, dynamic>> partidas = [
    {
      'nomeCompeticao': 'Copa 2026',
      'numeroRodada': 1,
      'timeCasa': 'Time A',
      'golsCasa': 3,
      'golsVisitante': 1,
      'wo': 0,
      'timeVisitante': 'Time B',
    },
    {
      'nomeCompeticao': 'Copa 2026',
      'numeroRodada': 2,
      'timeCasa': 'Time B',
      'golsCasa': 0,
      'golsVisitante': 0,
      'wo': 1,
      'timeVisitante': 'Time A',
    },
  ];

  final List<Map<String, dynamic>> suspensos = [
    {
      'nomeJogador': 'João Silva',
      'nomeTime': 'Time A',
      'motivo': 'Cartão vermelho',
      'qtdJogos': 2,
      'tipoEvento': 'Cartão vermelho',
      'minuto': 65,
    },
  ];

  final List<Map<String, dynamic>> financeiro = [
    {
      'nomeJogador': 'João Silva',
      'nomeTime': 'Time A',
      'numeroCamisa': 10,
      'valorInscricao': 150.0,
      'valorPago': 100.0,
    },
    {
      'nomeJogador': 'Maria Souza',
      'nomeTime': 'Time B',
      'numeroCamisa': 7,
      'valorInscricao': 150.0,
      'valorPago': 0.0,
    },
  ];

  final List<Map<String, dynamic>> eventos = [
    {'tipo': 'Gol', 'total': 4},
    {'tipo': 'Cartão amarelo', 'total': 1},
  ];

  // RNFR-15.1 — confere se o arquivo comecar como um PDF de verdade
  void esperaPdfValido(Uint8List bytes, String nomeRelatorio) {
    String inicio = String.fromCharCodes(bytes.sublist(0, 5));
    expect(inicio, equals('%PDF-'),
        reason: '$nomeRelatorio não gerou um PDF válido');
    expect(bytes.length, greaterThan(500),
        reason: '$nomeRelatorio gerou um arquivo pequeno demais');
  }

  group('RNFR-15.1 — geração de PDF', () {
    test('classificação gera um PDF válido', () async {
      Uint8List bytes = await GeradorPdf().classificacao(classificacao);
      esperaPdfValido(bytes, 'classificação');
    });

    test('histórico de partidas gera um PDF válido', () async {
      Uint8List bytes = await GeradorPdf().historicoPartidas(partidas);
      esperaPdfValido(bytes, 'histórico de partidas');
    });

    test('jogadores suspensos gera um PDF válido', () async {
      Uint8List bytes = await GeradorPdf().jogadoresSuspensos(suspensos);
      esperaPdfValido(bytes, 'jogadores suspensos');
    });

    test('relatório financeiro gera um PDF válido', () async {
      Uint8List bytes = await GeradorPdf().relatorioFinanceiro(
        financeiro,
        100.0,
      );
      esperaPdfValido(bytes, 'relatório financeiro');
    });

    test('estatísticas do jogador gera um PDF válido', () async {
      Uint8List bytes = await GeradorPdf().estatisticasJogador(
        'Inscrição 1',
        eventos,
        2,
        5,
      );
      esperaPdfValido(bytes, 'estatísticas do jogador');
    });

    test('relatório sem registros ainda gera um PDF', () async {
      Uint8List bytes = await GeradorPdf().classificacao([]);
      esperaPdfValido(bytes, 'classificação vazia');
    });

    test('o PDF não fica vazio quando o texto tem caracteres acentuados',
        () async {
      List<Map<String, dynamic>> dados = [
        {
          'nomeTime': 'Égua Futebol Clube',
          'pontos': 1,
          'jogos': 1,
          'vitorias': 0,
          'empates': 1,
          'derrotas': 0,
          'golsPro': 0,
          'golsContra': 0,
        },
      ];

      Uint8List bytes = await GeradorPdf().classificacao(dados);
      esperaPdfValido(bytes, 'classificação com acentos');
    });
  });

  group('Exportacao (RNFR-15.1)', () {
    test('nomeComData monta um nome de arquivo com data e hora', () {
      String nome = Exportacao.nomeComData("relatorio");

      expect(nome.startsWith('relatorio_'), isTrue);
      expect(nome.endsWith('.pdf'), isTrue);
      // relatorio_ (10) + AAAAMMDD (8) + _ (1) + HHMMSS (6) + .pdf (4)
      expect(nome.length, equals(10 + 8 + 1 + 6 + 4), reason: nome);
      expect(nome.contains(RegExp(r'\d{8}_\d{6}')), isTrue, reason: nome);
    });
  });
}
