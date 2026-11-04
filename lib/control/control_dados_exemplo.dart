import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/model/documento.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/model/modalidade.dart';
import 'package:projeto_final/model/posicao.dart';
import 'package:projeto_final/model/responsavel.dart';
import 'package:projeto_final/model/tecnico.dart';
import 'package:projeto_final/model/time.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:sqflite/sqflite.dart';

/// Popula o banco com dados de exemplo independentes (sem FK cruzadas).
class ControlDadosExemplo {
  static final ControlDadosExemplo _instancia = ControlDadosExemplo._();
  ControlDadosExemplo._();
  factory ControlDadosExemplo() => _instancia;

  Future<bool> bancoVazio() async {
    final banco = await BancoDados().db;
    final r = await banco.rawQuery("SELECT COUNT(*) AS total FROM modalidade");
    return (r.first['total'] as int? ?? 0) == 0;
  }

  Future<String> popular() async {
    await BancoDados().inserir("modalidade", Modalidade(id: 1, nome: "Futsal").toMap());
    await BancoDados().inserir("modalidade", Modalidade(id: 2, nome: "Vôlei").toMap());

    await BancoDados().inserir("categoria", Categoria(id: 1, nome: "Sub-15", idadeMin: 12, idadeMax: 15).toMap());
    await BancoDados().inserir("categoria", Categoria(id: 2, nome: "Sub-17", idadeMin: 15, idadeMax: 17).toMap());

    await BancoDados().inserir("tipo_evento", TipoEvento(id: 1, descricao: "Gol").toMap());
    await BancoDados().inserir("tipo_evento", TipoEvento(id: 2, descricao: "Cartão amarelo").toMap());
    await BancoDados().inserir("tipo_evento", TipoEvento(id: 3, descricao: "Cartão vermelho").toMap());

    await BancoDados().inserir("posicao", Posicao(id: 1, nome: "Goleiro", idModalidade: 1).toMap());
    await BancoDados().inserir("posicao", Posicao(id: 2, nome: "Fixo", idModalidade: 1).toMap());
    await BancoDados().inserir("posicao", Posicao(id: 3, nome: "Ala", idModalidade: 1).toMap());
    await BancoDados().inserir("posicao", Posicao(id: 4, nome: "Pivô", idModalidade: 1).toMap());

    await BancoDados().inserir("responsavel", Responsavel(id: 1, nome: "Maria Silva", cpf: "12345678900", telefone: "15999998888", email: "maria@email.com", parentesco: "Mãe").toMap());

    await BancoDados().inserir("jogador", Jogador(id: 1, cpf: "11122233344", nome: "João Pedro", dataNascimento: "2010-05-10", idResponsavel: 1, idPosicao: 3, numeroCamisa: 9).toMap());
    await BancoDados().inserir("jogador", Jogador(id: 2, cpf: "22233344455", nome: "Carlos Lima", dataNascimento: "2009-08-20", idResponsavel: 1, idPosicao: 2, numeroCamisa: 10).toMap());
    await BancoDados().inserir("jogador", Jogador(id: 3, cpf: "33344455566", nome: "Ana Souza", dataNascimento: "2011-03-15", idResponsavel: 1, idPosicao: 4, numeroCamisa: 7).toMap());

    await BancoDados().inserir("documento", Documento(idJogador: 1, tipoDocumento: "RG", caminhoArquivo: "/docs/joao_rg.pdf").toMap());

    await BancoDados().inserir("escola", Escola(id: 1, nome: "Escola São Bento", cidade: "Itapetininga", estado: "SP", telefone: "1533224455").toMap());
    await BancoDados().inserir("escola", Escola(id: 2, nome: "Colégio Objetivo", cidade: "Itapetininga", estado: "SP", telefone: "1533335566").toMap());

    await BancoDados().inserir("tecnico", Tecnico(id: 1, nome: "Professor Zé", telefone: "15999997777", email: "ze@email.com").toMap());

    await BancoDados().inserir("time", Time(idTime: 1, nomeTime: "Tigres", idEscola: 1, idCategoria: 1).toMap());
    await BancoDados().inserir("time", Time(idTime: 2, nomeTime: "Águias", idEscola: 2, idCategoria: 1).toMap());

    return "Banco populado com dados básicos independentes.";
  }
}