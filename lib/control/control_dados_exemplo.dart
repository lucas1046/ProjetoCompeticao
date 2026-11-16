import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:projeto_final/control/banco_dados.dart';
import 'package:sqflite/sqflite.dart';

class ControlDadosExemplo {
  static final ControlDadosExemplo _instancia = ControlDadosExemplo._();
  ControlDadosExemplo._();
  factory ControlDadosExemplo() => _instancia;

  Future<bool> bancoVazio() async {
    final banco = await BancoDados().db;
    final r = await banco.rawQuery("SELECT COUNT(*) AS total FROM escola");
    return (r.first['total'] as int? ?? 0) == 0;
  }

  // Remove caracteres nao alfabeticos para fazer um match flexivel
  String _norm(String val) {
    return val.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
  }

  // Extrai apenas os dígitos numéricos da categoria (ex: "SUB 10 - A" -> "10")
  String _extrairNumeroCategoria(String val) {
    final match = RegExp(r'[0-9]+').firstMatch(val);
    return match != null ? match.group(0)! : '';
  }

  Future<String> importarPlanilha() async {
    final banco = await BancoDados().db;
    String conteudo = await rootBundle.loadString('assets/planilha_copa.json');
    Map<String, dynamic> dados = jsonDecode(conteudo);

    await banco.transaction((txn) async {
      // 1. Limpa todas as tabelas envolvidas (para não duplicar em re-execuções)
      await txn.delete('evento_partida');
      await txn.delete('escalacao');
      await txn.delete('jogador_time');
      await txn.delete('participacao_jogador_time');
      await txn.delete('partida');
      await txn.delete('time');
      await txn.delete('rodada');
      await txn.delete('competicao');
      await txn.delete('jogador');
      await txn.delete('responsavel');
      await txn.delete('escola');
      await txn.delete('categoria');
      await txn.delete('tipo_evento');

      // 2. Inserir Tipos de Eventos Padrao
      await txn.insert('tipo_evento', {'id': 1, 'descricao': 'Gol'});
      await txn.insert('tipo_evento', {'id': 2, 'descricao': 'Cartão Amarelo/Vermelho'});

      // 3. Inserir Categorias
      final mapCat = <String, int>{}; // para buscar o ID depois
      for (var c in (dados['categorias'] as List)) {
        await txn.insert('categoria', {
          'id': c['id'], 'nome': c['nome'],
          'idade_min': c['idadeMin'], 'idade_max': c['idadeMax'],
        });
        
        String numCat = _extrairNumeroCategoria(c['nome'].toString());
        mapCat[numCat] = c['id'] as int;
      }

      // 4. Inserir Escolas
      final mapEscola = <String, int>{}; // Mapear nome da escola no banco pro ID
      for (var e in (dados['escolas'] as List)) {
        await txn.insert('escola', {
          'id': e['id'], 'nome': e['nome'], 'cidade': e['cidade'],
          'estado': e['estado'], 'telefone': '',
        });
        mapEscola[_norm(e['nome'])] = e['id'] as int;
      }

      // De-para de nome que vem na partida ("MANDANTE"/"VISITANTE") para o ID da escola
      int getEscolaId(String nomePlanilha) {
        String n = _norm(nomePlanilha);
        if (n.contains('anglo')) return mapEscola[_norm('Anglo')]!;
        if (n.contains('santamaria')) return mapEscola[_norm('Colégio Santa Maria')]!;
        if (n.contains('universitario')) return mapEscola[_norm('Colégio Universitário')]!;
        if (n.contains('objetivo')) return mapEscola[_norm('Colégio Objetivo')]!;
        if (n.contains('alpisveredas')) return mapEscola[_norm('Colégio Alpis Veredas')]!;
        if (n.contains('maplebear')) return mapEscola[_norm('Maple Bear')]!;
        if (n.contains('dombosco')) return mapEscola[_norm('Dom Bosco')]!;
        if (n.contains('ecoville')) return mapEscola[_norm('Colégio Ecoville')]!;
        if (n.contains('imaculada')) return mapEscola[_norm('Colégio Imaculada Conceição')]!;
        if (n.contains('coc')) return mapEscola[_norm('COC')]!;
        // fallback fallback
        return mapEscola.values.first;
      }

      // 5. Inserir Responsaveis
      for (int i = 0; i < (dados['responsaveis'] as List).length; i++) {
        var r = (dados['responsaveis'] as List)[i];
        await txn.insert('responsavel', {
          'id': r['id'], 'nome': r['nome'], 'cpf': 'resp${r['id']}',
          'telefone': '', 'email': '',
          'parentesco': r['parentesco'],
        });
      }

      // 6. Inserir Jogadores
      final mapJogador = <String, int>{};
      for (var j in (dados['jogadores'] as List)) {
        await txn.insert('jogador', {
          'id': j['id'], 'cpf': j['cpf'] ?? 'jog${j['id']}',
          'nome': j['nome'],
          'data_nascimento': j['dataNascimento'] ?? '2012-01-01',
          'id_responsavel': j['idResponsavel'], 'id_escola': j['idEscola'],
        });
        mapJogador[_norm(j['nome'])] = j['id'] as int;
      }

      // 7. Inserir Competicao
      int idCompeticao = await txn.insert('competicao', {
        'nome': 'COPA SKILL 2025',
        'cidade': 'Itapetininga',
        'data_inicio': '2025-01-01',
        'data_fim': '2025-12-31'
      });

      // 8. Processar Partidas (criando times e rodadas on the fly se necessário)
      final mapTimeCache = <String, int>{};
      final mapRodadaCache = <String, int>{};
      
      // Controle de participacoes para nao duplicar inscricoes
      final participacoesInscritas = <String>{};

      for (var p in (dados['partidas'] as List)) {
        // Categoria e Rodada
        String catRaw = p['categoria'].toString();
        String numCat = _extrairNumeroCategoria(catRaw);
        int? idCat = mapCat[numCat];
        if (idCat == null) continue; // se não achou categoria pula a partida
        
        // Pega o nome exato da categoria para colocar no nome do time
        String nomeCategoriaReal = (await txn.rawQuery('SELECT nome FROM categoria WHERE id = ?', [idCat])).first['nome'] as String;
        
        String numRodadaRaw = p['rodada'].toString().replaceAll(RegExp(r'[^0-9]'), '');
        if (numRodadaRaw.isEmpty) numRodadaRaw = '1';
        
        if (!mapRodadaCache.containsKey(numRodadaRaw)) {
          mapRodadaCache[numRodadaRaw] = await txn.insert('rodada', {
            'numero': int.parse(numRodadaRaw),
            'data': (p['data'] as String).substring(0, 10), // 'YYYY-MM-DD'
            'id_competicao': idCompeticao
          });
        }
        int idRodada = mapRodadaCache[numRodadaRaw]!;

        // Função local para pegar (ou criar) o Time
        Future<int> resolveTime(String lado) async {
          int idEscola = getEscolaId(lado);
          String chave = "${idEscola}_$idCat";
          if (!mapTimeCache.containsKey(chave)) {
            // pegar nome da escola real
            String nomeEscola = (await txn.rawQuery('SELECT nome FROM escola WHERE id = ?', [idEscola])).first['nome'] as String;
            mapTimeCache[chave] = await txn.insert('time', {
              'id_escola': idEscola,
              'id_categoria': idCat,
              'nome_time': '$nomeEscola $nomeCategoriaReal'
            });
          }
          return mapTimeCache[chave]!;
        }

        int idTimeCasa = await resolveTime(p['mandante'].toString());
        int idTimeVis = await resolveTime(p['visitante'].toString());

        // Calcula total de gols de cada lado na partida
        List escCasa = p['escalacao_casa'] as List? ?? [];
        List escVis = p['escalacao_visitante'] as List? ?? [];
        
        int golsCasa = 0;
        for (var j in escCasa) {
          golsCasa += (j['gols'] as num?)?.toInt() ?? 0;
        }
        
        int golsVis = 0;
        for (var j in escVis) {
          golsVis += (j['gols'] as num?)?.toInt() ?? 0;
        }

        // Partida
        int idPartida = await txn.insert('partida', {
          'id_rodada': idRodada,
          'id_time_casa': idTimeCasa,
          'id_time_visitante': idTimeVis,
          'qtd_gols_time_casa': golsCasa,
          'qtd_gols_time_visitante': golsVis,
          'wo': 0,
          'horario': (p['data'] as String).length > 11 ? (p['data'] as String).substring(11, 16) : '00:00'
        });

        // Processa escalação de um time
        Future<void> processaLado(List jList, int idTime) async {
          for (var esc in jList) {
            String nomeBusca = _norm(esc['nome']);
            if (!mapJogador.containsKey(nomeBusca)) continue; // Jogador nao na base
            int idJog = mapJogador[nomeBusca]!;

            // Participacao / JogadorTime
            String keyInsc = '${idJog}_$idTime';
            if (!participacoesInscritas.contains(keyInsc)) {
              await txn.insert(
                'jogador_time',
                {
                  'id_time': idTime,
                  'id_jogador': idJog,
                  'numero_camisa': esc['camisa'],
                },
                conflictAlgorithm: ConflictAlgorithm.ignore,
              );

              int idEscola = getEscolaId(idTime == idTimeCasa ? p['mandante'].toString() : p['visitante'].toString());
              
              // Verifica se ja possui participacao salva para evitar conflito da UNIQUE(id_jogador, id_escola)
              List<Map<String, dynamic>> pjtExistentes = await txn.rawQuery(
                'SELECT id FROM participacao_jogador_time WHERE id_jogador = ? AND id_escola = ?',
                [idJog, idEscola],
              );

              if (pjtExistentes.isEmpty) {
                int idPjt = await txn.insert(
                  'participacao_jogador_time',
                  {
                    'id_jogador': idJog,
                    'id_time': idTime,
                    'id_escola': idEscola,
                    'valor_inscricao': 50.0,
                  },
                  conflictAlgorithm: ConflictAlgorithm.ignore,
                );

                if (idPjt > 0) {
                  // Exemplo de pagamento aleatório para a amostra do relatório financeiro
                  if (idJog % 3 == 0) {
                    await txn.insert('pagamento_inscricao', {
                      'id_participacao_jogador_time': idPjt,
                      'valor_pago': 50.0,
                      'data_pagamento': '2025-02-10',
                      'forma_pagamento': 'Pix',
                      'observacoes': 'Pagamento integral'
                    });
                  } else if (idJog % 3 == 1) {
                    await txn.insert('pagamento_inscricao', {
                      'id_participacao_jogador_time': idPjt,
                      'valor_pago': 25.0,
                      'data_pagamento': '2025-02-12',
                      'forma_pagamento': 'Dinheiro',
                      'observacoes': 'Pagamento parcial'
                    });
                  }
                }
              }

              participacoesInscritas.add(keyInsc);
            }

            // Escalacao
            int idEscalacao = await txn.insert('escalacao', {
              'id_partida': idPartida,
              'id_jogador': idJog,
              'id_time': idTime,
              'titular': 'Titular'
            });

            // Gols
            int gols = (esc['gols'] as num?)?.toInt() ?? 0;
            for (int g = 0; g < gols; g++) {
              await txn.insert('evento_partida', {
                'id_tipo_evento': 1, // Gol
                'minuto_evento': 10 + g, // fictício só pra constar
                'descricao': 'Gol',
                'id_escalacao': idEscalacao
              });
            }

            // Cartoes e Suspensões
            if (esc['cartao'] != null) {
              int idEventoCartao = await txn.insert('evento_partida', {
                'id_tipo_evento': 2, // Cartão
                'minuto_evento': 30, // ficticio
                'descricao': esc['cartao'].toString(),
                'id_escalacao': idEscalacao
              });

              await txn.insert('suspensao', {
                'id_evento': idEventoCartao,
                'motivo': esc['cartao'].toString(),
                'qtd_jogos_suspensao': 1,
                'cumprida': 0
              });
            }
          }
        }

        await processaLado(p['escalacao_casa'] as List, idTimeCasa);
        await processaLado(p['escalacao_visitante'] as List, idTimeVis);
      }
    });

    int escolas = (await banco.rawQuery("SELECT COUNT(*) AS t FROM escola")).first['t'] as int;
    int responsaveis = (await banco.rawQuery("SELECT COUNT(*) AS t FROM responsavel")).first['t'] as int;
    int jogadores = (await banco.rawQuery("SELECT COUNT(*) AS t FROM jogador")).first['t'] as int;
    int partidas = (await banco.rawQuery("SELECT COUNT(*) AS t FROM partida")).first['t'] as int;
    int eventos = (await banco.rawQuery("SELECT COUNT(*) AS t FROM evento_partida")).first['t'] as int;

    return "Banco populado:\n$partidas partidas ($eventos eventos)\n$jogadores jogadores, $escolas escolas e $responsaveis responsáveis.";
  }
}
