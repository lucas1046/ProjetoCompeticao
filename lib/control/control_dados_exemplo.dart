import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:projeto_final/control/banco_dados.dart';

class ControlDadosExemplo {
  static final ControlDadosExemplo _instancia = ControlDadosExemplo._();
  ControlDadosExemplo._();
  factory ControlDadosExemplo() => _instancia;

  Future<bool> bancoVazio() async {
    final banco = await BancoDados().db;
    final r = await banco.rawQuery("SELECT COUNT(*) AS total FROM escola");
    return (r.first['total'] as int? ?? 0) == 0;
  }

  Future<String> importarPlanilha() async {
    final banco = await BancoDados().db;
    String conteudo = await rootBundle.loadString('assets/planilha_copa.json');
    Map<String, dynamic> dados = jsonDecode(conteudo);

    await banco.transaction((txn) async {
      await txn.delete('jogador');
      await txn.delete('responsavel');
      await txn.delete('escola');
      await txn.delete('categoria');
      await txn.delete('tipo_evento');

      for (var c in (dados['categorias'] as List)) {
        await txn.insert('categoria', {
          'id': c['id'], 'nome': c['nome'],
          'idade_min': c['idadeMin'], 'idade_max': c['idadeMax'],
        });
      }
      for (var e in (dados['escolas'] as List)) {
        await txn.insert('escola', {
          'id': e['id'], 'nome': e['nome'], 'cidade': e['cidade'],
          'estado': e['estado'], 'telefone': null,
        });
      }
      for (var r in (dados['responsaveis'] as List)) {
        await txn.insert('responsavel', {
          'id': r['id'], 'nome': r['nome'], 'cpf': r['cpf'],
          'telefone': r['telefone'], 'email': r['email'],
          'parentesco': r['parentesco'],
        });
      }
      for (var j in (dados['jogadores'] as List)) {
        await txn.insert('jogador', {
          'id': j['id'], 'cpf': j['cpf'], 'nome': j['nome'],
          'data_nascimento': j['dataNascimento'],
          'id_responsavel': j['idResponsavel'], 'id_escola': j['idEscola'],
        });
      }
    });

    return "Banco populado com ${((dados['jogadores'] as List).length)} jogadores da planilha COPA SKILL 2025.";
  }
}