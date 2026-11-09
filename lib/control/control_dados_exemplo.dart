import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/model/responsavel.dart';
import 'package:projeto_final/model/tipo_evento.dart';

class ControlDadosExemplo {
  static final ControlDadosExemplo _instancia = ControlDadosExemplo._();
  ControlDadosExemplo._();
  factory ControlDadosExemplo() => _instancia;

  Future<bool> bancoVazio() async {
    final banco = await BancoDados().db;
    final r = await banco.rawQuery("SELECT COUNT(*) AS total FROM escola");
    return (r.first['total'] as int? ?? 0) == 0;
  }

  Future<String> popular() async {
    final banco = await BancoDados().db;
    for (final t in ['jogador','responsavel','escola','categoria','tipo_evento']) {
      await banco.delete(t);
    }
    await BancoDados().inserir('escola', Escola(id: 1, nome: 'Anglo', cidade: 'Itapetininga', estado: 'SP', telefone: '').toMap());
    await BancoDados().inserir('escola', Escola(id: 2, nome: 'COC', cidade: 'Itapetininga', estado: 'SP', telefone: '').toMap());
    await BancoDados().inserir('escola', Escola(id: 3, nome: 'Colégio Objetivo', cidade: 'Itapetininga', estado: 'SP', telefone: '').toMap());
    await BancoDados().inserir('escola', Escola(id: 4, nome: 'Colégio Santa Maria', cidade: 'Itapetininga', estado: 'SP', telefone: '').toMap());
    await BancoDados().inserir('escola', Escola(id: 5, nome: 'Maple Bear', cidade: 'Itapetininga', estado: 'SP', telefone: '').toMap());
    await BancoDados().inserir('categoria', Categoria(id: 1, nome: 'Sub 8', idadeMin: 6, idadeMax: 8).toMap());
    await BancoDados().inserir('categoria', Categoria(id: 2, nome: 'Sub 9', idadeMin: 7, idadeMax: 9).toMap());
    await BancoDados().inserir('categoria', Categoria(id: 3, nome: 'Sub 10', idadeMin: 8, idadeMax: 10).toMap());
    await BancoDados().inserir('categoria', Categoria(id: 4, nome: 'Sub 11', idadeMin: 9, idadeMax: 11).toMap());
    await BancoDados().inserir('categoria', Categoria(id: 5, nome: 'Sub 13', idadeMin: 11, idadeMax: 13).toMap());
    await BancoDados().inserir('categoria', Categoria(id: 6, nome: 'Sub 14', idadeMin: 12, idadeMax: 14).toMap());
    await BancoDados().inserir('categoria', Categoria(id: 7, nome: 'Sub 16', idadeMin: 14, idadeMax: 16).toMap());
    await BancoDados().inserir('categoria', Categoria(id: 8, nome: 'Sub 18', idadeMin: 16, idadeMax: 18).toMap());
    await BancoDados().inserir('tipo_evento', TipoEvento(id: 1, descricao: 'Gol').toMap());
    await BancoDados().inserir('tipo_evento', TipoEvento(id: 2, descricao: 'Cartão amarelo').toMap());
    await BancoDados().inserir('tipo_evento', TipoEvento(id: 3, descricao: 'Cartão vermelho').toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 1, nome: 'Tiago Larotonda', cpf: 'resp1', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 1, cpf: 'jog1', nome: 'Afonso Larotonda', dataNascimento: '2019-03-12', idResponsavel: 1, idEscola: 3).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 2, nome: 'Abner Luciano França de Lima', cpf: 'resp2', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 2, cpf: 'jog2', nome: 'Abner Bryan Bueno de Lima', dataNascimento: '2012-06-27', idResponsavel: 2, idEscola: 4).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 3, nome: 'LAURA TAMURA STTEFANO GRANERO', cpf: 'resp3', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 3, cpf: 'jog3', nome: 'André Granero', dataNascimento: '2010-12-21', idResponsavel: 3, idEscola: 3).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 4, nome: 'MARIA CAROLINA ARAUJO DE OLIVEIRA MAGALDI', cpf: 'resp4', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 4, cpf: 'jog4', nome: 'Antônio Araújo magaldi', dataNascimento: '2015-08-01', idResponsavel: 4, idEscola: 3).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 5, nome: 'Fabíola Gobbo Dalcin', cpf: 'resp5', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 5, cpf: 'jog5', nome: 'Antonio Gobbo Dalcin', dataNascimento: '2016-04-29', idResponsavel: 5, idEscola: 3).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 6, nome: 'LUCIAN ELAN DOS SANTOS SARDEMBERG', cpf: 'resp6', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 6, cpf: 'jog6', nome: 'Anthony José Gonçalves sardemberg', dataNascimento: '2014-06-17', idResponsavel: 6, idEscola: 2).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 7, nome: 'Marília Rodrigues Torres Herkes Panis', cpf: 'resp7', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 7, cpf: 'jog7', nome: 'Antonio Herkes Panis', dataNascimento: '2014-06-18', idResponsavel: 7, idEscola: 3).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 8, nome: 'Silmara Fraga da Silva', cpf: 'resp8', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 8, cpf: 'jog8', nome: 'Antonio Augusto Fraga dos Santos', dataNascimento: '2009-01-27', idResponsavel: 8, idEscola: 1).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 9, nome: 'Lilian cristina haidar', cpf: 'resp9', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 9, cpf: 'jog9', nome: 'Antônio tadeu haidar malavazzi', dataNascimento: '2015-01-11', idResponsavel: 9, idEscola: 1).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 10, nome: 'Gisiane Fernanda Ferreira Orsi do Amaral', cpf: 'resp10', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 10, cpf: 'jog10', nome: 'Antonio Luiz Rolim do Amaral Neto', dataNascimento: '2011-12-19', idResponsavel: 10, idEscola: 3).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 11, nome: 'Vitor Alessandro Maruno', cpf: 'resp11', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 11, cpf: 'jog11', nome: 'Artur Pontes Maruno', dataNascimento: '2015-05-13', idResponsavel: 11, idEscola: 3).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 12, nome: 'Ana Paula Lobo Delfino Santiago de Oliveira', cpf: 'resp12', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 12, cpf: 'jog12', nome: 'Liz Lobo Delfino Santiago de Oliveira', dataNascimento: '2018-04-16', idResponsavel: 12, idEscola: 5).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 13, nome: 'Juliane Loenert Araujo Oliveira', cpf: 'resp13', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 13, cpf: 'jog13', nome: 'Antonio Loenert Araujo de Oliveira', dataNascimento: '2018-12-03', idResponsavel: 13, idEscola: 2).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 14, nome: 'Vanessa Oliveira', cpf: 'resp14', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 14, cpf: 'jog14', nome: 'Arthur Kawalciuk Santos Carvalho', dataNascimento: '2008-04-30', idResponsavel: 14, idEscola: 1).toMap());
    await BancoDados().inserir('responsavel', Responsavel(id: 15, nome: 'Ana Cecilia Hungria Françani', cpf: 'resp15', telefone: '', email: '', parentesco: 'Responsável').toMap());
    await BancoDados().inserir('jogador', Jogador(id: 15, cpf: 'jog15', nome: 'Benjamin Hungria Francani', dataNascimento: '2015-07-23', idResponsavel: 15, idEscola: 3).toMap());
    return 'Banco populado com dados da planilha COPA SKILL 2025.';
  }
}