import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:projeto_final/control/control_sessao.dart';
import 'package:projeto_final/main.dart';
import 'package:projeto_final/model/usuario.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:projeto_final/model/documento.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/model/escalacao.dart';
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
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/telas/tela_adicionar_competicao.dart';
import 'package:projeto_final/telas/tela_adicionar_modalidade.dart';

void main() {
  setUp(() => ControlSessao().sair());

  // RNFR-15.2 — sem sessao o app abre na tela de login
  testWidgets('App abre no login quando nao ha sessao', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(Menu), findsNothing);
    expect(find.text('Acesso ao sistema'), findsOneWidget);
  });

  testWidgets('Menu exibe as 5 entidades do cadastro basico',
      (WidgetTester tester) async {
    _logaComoAdmin();
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(Menu), findsOneWidget);
    expect(find.text('Competição'), findsOneWidget);
    expect(find.text('Tipo de evento'), findsOneWidget);

    // O GridView e lazy: o ultimo card precisa de scroll para aparecer
    await tester.scrollUntilVisible(
      find.text('Posição'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Posição'), findsOneWidget);
  });

  testWidgets('Navega para o cadastro de competicao',
      (WidgetTester tester) async {
    _logaComoAdmin();
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Card do menu -> tela de detalhe -> botao Cadastrar
    await tester.tap(find.text('Competição'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Cadastrar'));
    await tester.pumpAndSettle();

    expect(find.byType(TelaAdicionarCompeticao), findsOneWidget);
    expect(find.text('Registrar'), findsOneWidget);
  });

  testWidgets('Usuario comum nao ve Responsavel nem Documento no menu',
      (tester) async {
    ControlSessao().entrar(Usuario(
      login: 'joao',
      senhaHash: 'x',
      perfil: Usuario.usuarioComum,
    ));

    // O GridView monta so os cards que cabem na tela; um celular grande o
    // bastante para ver todos de uma vez deixa o teste determinístico
    tester.view.physicalSize = Size(1080, 8000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(Menu), findsOneWidget);
    expect(find.text('Responsável'), findsNothing);
    expect(find.text('Documento'), findsNothing);
    expect(find.text('Jogador'), findsOneWidget);
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

  test('Model Responsavel converte para Map e volta', () {
    Responsavel r = Responsavel(
      id: 1,
      nome: 'Maria Silva',
      cpf: '12345678900',
      telefone: '15999998888',
      email: 'maria@email.com',
      parentesco: 'Mãe',
    );
    Responsavel deVolta = Responsavel.fromMap(r.toMap());

    expect(deVolta.nome, 'Maria Silva');
    expect(deVolta.cpf, '12345678900');
    expect(deVolta.parentesco, 'Mãe');
  });

  test('Model Jogador converte para Map e volta', () {
    Jogador j = Jogador(
      id: 1,
      cpf: '11122233344',
      nome: 'João Pedro',
      dataNascimento: '2010-05-10',
      idResponsavel: 1,
    );
    Jogador deVolta = Jogador.fromMap(j.toMap());

    expect(deVolta.nome, 'João Pedro');
    expect(deVolta.dataNascimento, '2010-05-10');
    expect(deVolta.idResponsavel, 1);
  });

  test('Model Documento converte para Map e volta', () {
    Documento d = Documento(
      id: 1,
      idJogador: 1,
      tipoDocumento: 'RG',
      caminhoArquivo: '/docs/rg.pdf',
    );
    Documento deVolta = Documento.fromMap(d.toMap());

    expect(deVolta.tipoDocumento, 'RG');
    expect(deVolta.idJogador, 1);
  });

  test('Model Escola converte para Map e volta', () {
    Escola e = Escola(
      id: 1,
      nome: 'Escola São Bento',
      cidade: 'Itapetininga',
      estado: 'SP',
      telefone: '1533224455',
    );
    Escola deVolta = Escola.fromMap(e.toMap());

    expect(deVolta.nome, 'Escola São Bento');
    expect(deVolta.estado, 'SP');
  });

  test('Model Tecnico converte para Map e volta', () {
    Tecnico t = Tecnico(
      id: 1,
      nome: 'Professor Zé',
      telefone: '15999997777',
      email: 'ze@email.com',
    );
    Tecnico deVolta = Tecnico.fromMap(t.toMap());

    expect(deVolta.nome, 'Professor Zé');
    expect(deVolta.email, 'ze@email.com');
  });

  test('Model Time converte para Map e volta', () {
    Time t = Time(
      idTime: 1,
      nomeTime: 'Tigres',
      idEscola: 1,
      idCategoria: 1,
    );
    Time deVolta = Time.fromMap(t.toMap());

    expect(deVolta.nomeTime, 'Tigres');
    expect(deVolta.idEscola, 1);
    expect(deVolta.idCategoria, 1);
  });

  test('Model FotoFigurinha converte para Map e volta', () {
    FotoFigurinha f = FotoFigurinha(
      id: 1,
      caminhoArquivo: '/fotos/jogador.png',
      dataUpload: '2026-03-01',
    );
    FotoFigurinha deVolta = FotoFigurinha.fromMap(f.toMap());

    expect(deVolta.caminhoArquivo, '/fotos/jogador.png');
    expect(deVolta.dataUpload, '2026-03-01');
  });

  test('Model TecnicoTime converte para Map e volta', () {
    TecnicoTime t = TecnicoTime(idTecnico: 1, idTime: 2);
    TecnicoTime deVolta = TecnicoTime.fromMap(t.toMap());

    expect(deVolta.idTecnico, 1);
    expect(deVolta.idTime, 2);
  });

  test('Model ParticipacaoJogadorTime converte para Map e volta', () {
    ParticipacaoJogadorTime p = ParticipacaoJogadorTime(
      id: 1,
      idJogador: 1,
      idEscola: 2,
      valorInscricao: 150.0,
    );
    ParticipacaoJogadorTime deVolta =
        ParticipacaoJogadorTime.fromMap(p.toMap());

    expect(deVolta.idEscola, 2);
    expect(deVolta.valorInscricao, 150.0);
  });

  test('Model PagamentoInscricao converte para Map e volta', () {
    PagamentoInscricao p = PagamentoInscricao(
      id: 1,
      idParticipacao: 1,
      valorPago: 150.0,
      dataPagamento: '2026-03-10',
      formaPagamento: 'Pix',
      observacoes: 'Pago',
    );
    PagamentoInscricao deVolta = PagamentoInscricao.fromMap(p.toMap());

    expect(deVolta.valorPago, 150.0);
    expect(deVolta.formaPagamento, 'Pix');
  });

  test('Model Rodada converte para Map e volta', () {
    Rodada r = Rodada(id: 1, numero: 1, data: '2026-03-01', idCompeticao: 1);
    Rodada deVolta = Rodada.fromMap(r.toMap());

    expect(deVolta.numero, 1);
    expect(deVolta.idCompeticao, 1);
  });

  test('Model Partida converte para Map e volta', () {
    Partida p = Partida(
      id: 1,
      idRodada: 1,
      idTimeCasa: 1,
      idTimeVisitante: 2,
      qtdGolsTimeCasa: 3,
      qtdGolsTimeVisitante: 1,
      wo: false,
    );
    Partida deVolta = Partida.fromMap(p.toMap());

    expect(deVolta.qtdGolsTimeCasa, 3);
    expect(deVolta.wo, false);
  });

  test('Model Escalacao converte para Map e volta', () {
    Escalacao e = Escalacao(
      id: 1,
      idPartida: 1,
      idJogador: 1,
    );
    Escalacao deVolta = Escalacao.fromMap(e.toMap());

    expect(deVolta.idJogador, 1);
  });

  test('Model EventoPartida converte para Map e volta', () {
    EventoPartida e = EventoPartida(
      id: 1,
      idTipoEvento: 1,
      minutoEvento: 35,
      descricao: 'Gol de cabeça',
      idEscalacao: 1,
    );
    EventoPartida deVolta = EventoPartida.fromMap(e.toMap());

    expect(deVolta.minutoEvento, 35);
    expect(deVolta.descricao, 'Gol de cabeça');
  });

  test('Model Suspensao converte para Map e volta', () {
    Suspensao s = Suspensao(
      id: 1,
      idEvento: 1,
      motivo: 'Cartão vermelho',
      qtdJogosSuspensao: 2,
      cumprida: false,
    );
    Suspensao deVolta = Suspensao.fromMap(s.toMap());

    expect(deVolta.motivo, 'Cartão vermelho');
    expect(deVolta.qtdJogosSuspensao, 2);
    expect(deVolta.cumprida, false);
  });
}

// Entra na sessao como administrador, que e o perfil usado pelos testes
// de navegacao do menu (RNFR-15.2).
void _logaComoAdmin() {
  ControlSessao().entrar(Usuario(
    login: 'admin',
    senhaHash: 'x',
    perfil: Usuario.administrador,
  ));
}
