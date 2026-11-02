import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:projeto_final/model/documento.dart';
import 'package:projeto_final/model/escalacao.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/model/evento_partida.dart';
import 'package:projeto_final/model/foto_figurinha.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/model/modalidade.dart';
import 'package:projeto_final/model/pagamento_inscricao.dart';
import 'package:projeto_final/model/participacao_jogador_time.dart';
import 'package:projeto_final/model/partida.dart';
import 'package:projeto_final/model/posicao.dart';
import 'package:projeto_final/model/responsavel.dart';
import 'package:projeto_final/model/rodada.dart';
import 'package:projeto_final/model/suspensao.dart';
import 'package:projeto_final/model/tecnico.dart';
import 'package:projeto_final/model/tecnico_time.dart';
import 'package:projeto_final/model/time.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:sqflite/sqflite.dart';

/// Popula o banco com dados de exemplo para testes.
class ControlDadosExemplo {
  static final ControlDadosExemplo _instancia = ControlDadosExemplo._();

  ControlDadosExemplo._();

  factory ControlDadosExemplo() => _instancia;

  // Verifica se o banco ja possui dados
  Future<bool> bancoVazio() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultado =
        await banco.rawQuery("SELECT COUNT(*) AS total FROM competicao");
    return (resultado.first['total'] as int? ?? 0) == 0;
  }

  // Insere todos os dados de exemplo e retorna o resumo
  Future<String> popular() async {

    // ---------------------------------------------------------
    // CADASTROS BASICOS
    // ---------------------------------------------------------
    await BancoDados().inserir(
      "modalidade",
      Modalidade(id: 1, nome: "Futsal").toMap(),
    );
    await BancoDados().inserir(
      "modalidade",
      Modalidade(id: 2, nome: "Vôlei").toMap(),
    );

    await BancoDados().inserir(
      "categoria",
      Categoria(id: 1, nome: "Sub-15", idadeMin: 12, idadeMax: 15).toMap(),
    );
    await BancoDados().inserir(
      "categoria",
      Categoria(id: 2, nome: "Sub-17", idadeMin: 15, idadeMax: 17).toMap(),
    );

    await BancoDados().inserir(
      "tipo_evento",
      TipoEvento(id: 1, descricao: "Gol").toMap(),
    );
    await BancoDados().inserir(
      "tipo_evento",
      TipoEvento(id: 2, descricao: "Cartão amarelo").toMap(),
    );
    await BancoDados().inserir(
      "tipo_evento",
      TipoEvento(id: 3, descricao: "Cartão vermelho").toMap(),
    );

    await BancoDados().inserir(
      "posicao",
      Posicao(id: 1, nome: "Goleiro", idModalidade: 1).toMap(),
    );
    await BancoDados().inserir(
      "posicao",
      Posicao(id: 2, nome: "Fixo", idModalidade: 1).toMap(),
    );
    await BancoDados().inserir(
      "posicao",
      Posicao(id: 3, nome: "Ala", idModalidade: 1).toMap(),
    );
    await BancoDados().inserir(
      "posicao",
      Posicao(id: 4, nome: "Pivô", idModalidade: 1).toMap(),
    );
    await BancoDados().inserir(
      "posicao",
      Posicao(id: 5, nome: "Levantador", idModalidade: 2).toMap(),
    );
    await BancoDados().inserir(
      "posicao",
      Posicao(id: 6, nome: "Ponteiro", idModalidade: 2).toMap(),
    );

    // ---------------------------------------------------------
    // PESSOAS
    // ---------------------------------------------------------
    await BancoDados().inserir(
      "responsavel",
      Responsavel(
        id: 1,
        nome: "Maria Silva",
        cpf: "12345678900",
        telefone: "15999998888",
        email: "maria@email.com",
        parentesco: "Mãe",
      ).toMap(),
    );

    await BancoDados().inserir(
      "jogador",
      Jogador(
        id: 1,
        cpf: "11122233344",
        nome: "João Pedro",
        dataNascimento: "2010-05-10",
        idResponsavel: 1,
      ).toMap(),
    );
    await BancoDados().inserir(
      "jogador",
      Jogador(
        id: 2,
        cpf: "22233344455",
        nome: "Carlos Lima",
        dataNascimento: "2009-08-20",
        idResponsavel: 1,
      ).toMap(),
    );
    await BancoDados().inserir(
      "jogador",
      Jogador(
        id: 3,
        cpf: "33344455566",
        nome: "Ana Souza",
        dataNascimento: "2011-03-15",
        idResponsavel: 1,
      ).toMap(),
    );

    await BancoDados().inserir(
      "documento",
      Documento(
        idJogador: 1,
        tipoDocumento: "RG",
        caminhoArquivo: "/docs/joao_rg.pdf",
      ).toMap(),
    );
    await BancoDados().inserir(
      "documento",
      Documento(
        idJogador: 1,
        tipoDocumento: "CPF",
        caminhoArquivo: "/docs/joao_cpf.pdf",
      ).toMap(),
    );
    await BancoDados().inserir(
      "documento",
      Documento(
        idJogador: 2,
        tipoDocumento: "RG",
        caminhoArquivo: "/docs/carlos_rg.pdf",
      ).toMap(),
    );
    await BancoDados().inserir(
      "documento",
      Documento(
        idJogador: 3,
        tipoDocumento: "RG",
        caminhoArquivo: "/docs/ana_rg.pdf",
      ).toMap(),
    );

    // ---------------------------------------------------------
    // ESTRUTURA
    // ---------------------------------------------------------
    await BancoDados().inserir(
      "escola",
      Escola(
        id: 1,
        nome: "Escola São Bento",
        cidade: "Itapetininga",
        estado: "SP",
        telefone: "1533224455",
      ).toMap(),
    );
    await BancoDados().inserir(
      "escola",
      Escola(
        id: 2,
        nome: "Colégio Objetivo",
        cidade: "Itapetininga",
        estado: "SP",
        telefone: "1533335566",
      ).toMap(),
    );

    await BancoDados().inserir(
      "tecnico",
      Tecnico(
        id: 1,
        nome: "Professor Zé",
        telefone: "15999997777",
        email: "ze@email.com",
      ).toMap(),
    );
    await BancoDados().inserir(
      "tecnico",
      Tecnico(
        id: 2,
        nome: "Professora Ana",
        telefone: "15988886666",
        email: "ana@email.com",
      ).toMap(),
    );

    await BancoDados().inserir(
      "time",
      Time(
        idTime: 1,
        nomeTime: "Tigres",
        idModalidade: 1,
        idEscola: 1,
        idCategoria: 1,
      ).toMap(),
    );
    await BancoDados().inserir(
      "time",
      Time(
        idTime: 2,
        nomeTime: "Águias",
        idModalidade: 1,
        idEscola: 2,
        idCategoria: 1,
      ).toMap(),
    );
    await BancoDados().inserir(
      "time",
      Time(
        idTime: 3,
        nomeTime: "Lobos",
        idModalidade: 2,
        idEscola: 1,
        idCategoria: 2,
      ).toMap(),
    );

    // ---------------------------------------------------------
    // VINCULOS
    // ---------------------------------------------------------
    await BancoDados().inserir(
      "tecnico_time",
      TecnicoTime(idTecnico: 1, idTime: 1).toMap(),
    );
    await BancoDados().inserir(
      "tecnico_time",
      TecnicoTime(idTecnico: 2, idTime: 2).toMap(),
    );

    await BancoDados().inserir(
      "participacao_jogador_time",
      ParticipacaoJogadorTime(
        id: 1,
        idJogador: 1,
        idEscola: 1,
        valorInscricao: 150.0,
      ).toMap(),
    );
    await BancoDados().inserir(
      "participacao_jogador_time",
      ParticipacaoJogadorTime(
        id: 2,
        idJogador: 2,
        idEscola: 2,
        valorInscricao: 150.0,
      ).toMap(),
    );
    await BancoDados().inserir(
      "participacao_jogador_time",
      ParticipacaoJogadorTime(
        id: 3,
        idJogador: 3,
        idEscola: 1,
        valorInscricao: 150.0,
      ).toMap(),
    );

    // ---------------------------------------------------------
    // COMPETICAO
    // ---------------------------------------------------------
    await BancoDados().inserir(
      "competicao",
      Competicao(
        id: 1,
        nome: "Copa Itapetininga de Futsal",
        cidade: "Itapetininga",
        dataInicio: "2026-03-01",
        dataFim: "2026-03-31",
      ).toMap(),
    );

    await BancoDados().inserir(
      "rodada",
      Rodada(id: 1, numero: 1, data: "2026-03-08", idCompeticao: 1).toMap(),
    );

    await BancoDados().inserir(
      "partida",
      Partida(
        id: 1,
        idRodada: 1,
        idTimeCasa: 1,
        idTimeVisitante: 2,
        qtdGolsTimeCasa: 3,
        qtdGolsTimeVisitante: 1,
      ).toMap(),
    );
    await BancoDados().inserir(
      "partida",
      Partida(
        id: 2,
        idRodada: 1,
        idTimeCasa: 1,
        idTimeVisitante: 3,
        qtdGolsTimeCasa: 2,
        qtdGolsTimeVisitante: 2,
      ).toMap(),
    );

    // ---------------------------------------------------------
    // ESCALACAO
    // ---------------------------------------------------------
    await BancoDados().inserir(
      "escalacao",
      Escalacao(
        id: 1,
        idPartida: 1,
        idJogador: 1,
        idTime: 1,
      ).toMap(),
    );
    await BancoDados().inserir(
      "escalacao",
      Escalacao(
        id: 2,
        idPartida: 1,
        idJogador: 3,
        idTime: 1,
      ).toMap(),
    );
    await BancoDados().inserir(
      "escalacao",
      Escalacao(
        id: 3,
        idPartida: 1,
        idJogador: 2,
        idTime: 2,
      ).toMap(),
    );

    // ---------------------------------------------------------
    // EVENTOS
    // ---------------------------------------------------------
    await BancoDados().inserir(
      "evento_partida",
      EventoPartida(
        id: 1,
        idTipoEvento: 1,
        minutoEvento: 35,
        descricao: "Gol de camisa 9",
        idEscalacao: 1,
      ).toMap(),
    );
    await BancoDados().inserir(
      "evento_partida",
      EventoPartida(
        id: 2,
        idTipoEvento: 1,
        minutoEvento: 52,
        descricao: "Gol de camisa 7",
        idEscalacao: 2,
      ).toMap(),
    );
    await BancoDados().inserir(
      "evento_partida",
      EventoPartida(
        id: 3,
        idTipoEvento: 2,
        minutoEvento: 60,
        descricao: "Cartão amarelo para camisa 10",
        idEscalacao: 3,
      ).toMap(),
    );

    // ---------------------------------------------------------
    // SUSPENSAO (originada pelo cartão amarelo)
    // ---------------------------------------------------------
    await BancoDados().inserir(
      "suspensao",
      Suspensao(
        id: 1,
        idEvento: 3,
        motivo: "Acumulo de cartoes",
        qtdJogosSuspensao: 1,
        cumprida: false,
      ).toMap(),
    );

    // ---------------------------------------------------------
    // FINANCEIRO
    // ---------------------------------------------------------
    await BancoDados().inserir(
      "pagamento_inscricao",
      PagamentoInscricao(
        idParticipacao: 1,
        valorPago: 100.0,
        dataPagamento: "2026-03-01",
        formaPagamento: "Pix",
        observacoes: "Pagamento parcial",
      ).toMap(),
    );
    await BancoDados().inserir(
      "pagamento_inscricao",
      PagamentoInscricao(
        idParticipacao: 2,
        valorPago: 150.0,
        dataPagamento: "2026-03-02",
        formaPagamento: "Dinheiro",
        observacoes: "Pago integral",
      ).toMap(),
    );

    // ---------------------------------------------------------
    // FOTO
    // ---------------------------------------------------------
    await BancoDados().inserir(
      "foto_figurinha",
      FotoFigurinha(
        id: 1,
        caminhoArquivo: "/fotos/joao_pedro.png",
        dataUpload: "2026-03-01",
      ).toMap(),
    );

    return "Banco populado com dados de exemplo:\n"
        "- 2 modalidades, 2 categorias, 3 tipos de evento, 6 posições\n"
        "- 3 jogadores, 1 responsável, 4 documentos\n"
        "- 2 escolas, 2 técnicos, 3 times\n"
        "- 3 inscrições, 2 pagamentos\n"
        "- 1 competição, 1 rodada, 2 partidas\n"
        "- 6 escalações (3 por partida + 3 roster), 3 eventos, 1 suspensão";
  }
}
