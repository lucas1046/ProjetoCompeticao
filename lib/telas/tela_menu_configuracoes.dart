import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/telas/tela_adicionar_competicao.dart';
import 'package:projeto_final/telas/tela_consulta_competicao.dart';
import 'package:projeto_final/telas/tela_adicionar_time.dart';
import 'package:projeto_final/telas/tela_consulta_time.dart';
import 'package:projeto_final/telas/tela_adicionar_escola.dart';
import 'package:projeto_final/telas/tela_consulta_escola.dart';
import 'package:projeto_final/telas/tela_adicionar_categoria.dart';
import 'package:projeto_final/telas/tela_consulta_categoria.dart';
import 'package:projeto_final/telas/tela_adicionar_modalidade.dart';
import 'package:projeto_final/telas/tela_consulta_modalidade.dart';
import 'package:projeto_final/telas/tela_adicionar_posicao.dart';
import 'package:projeto_final/telas/tela_consulta_posicao.dart';
import 'package:projeto_final/telas/tela_adicionar_tipo_evento.dart';
import 'package:projeto_final/telas/tela_consulta_tipo_evento.dart';
import 'package:projeto_final/telas/tela_adicionar_evento.dart';
import 'package:projeto_final/telas/tela_consulta_evento.dart';
import 'package:projeto_final/telas/tela_adicionar_jogador.dart';
import 'package:projeto_final/telas/tela_consulta_jogador.dart';
import 'package:projeto_final/telas/tela_adicionar_responsavel.dart';
import 'package:projeto_final/telas/tela_consulta_responsavel.dart';
import 'package:projeto_final/telas/tela_adicionar_tecnico.dart';
import 'package:projeto_final/telas/tela_consulta_tecnico.dart';
import 'package:projeto_final/telas/tela_adicionar_documento.dart';
import 'package:projeto_final/telas/tela_consulta_documento.dart';
import 'package:projeto_final/telas/tela_adicionar_foto.dart';
import 'package:projeto_final/telas/tela_consulta_foto.dart';
import 'package:projeto_final/telas/tela_adicionar_rodada.dart';
import 'package:projeto_final/telas/tela_consulta_rodada.dart';
import 'package:projeto_final/telas/tela_adicionar_partida.dart';
import 'package:projeto_final/telas/tela_consulta_partida.dart';
import 'package:projeto_final/telas/tela_adicionar_participacao.dart';
import 'package:projeto_final/telas/tela_consulta_participacao.dart';
import 'package:projeto_final/telas/tela_adicionar_pagamento.dart';
import 'package:projeto_final/telas/tela_consulta_pagamento.dart';
import 'package:projeto_final/telas/tela_adicionar_suspensao.dart';
import 'package:projeto_final/telas/tela_consulta_suspensao.dart';
import 'package:projeto_final/telas/tela_dados_exemplo.dart';
import 'package:projeto_final/telas/tela_detalhe_entidade.dart';

/// Menu de configurações com item para cada entidade e dados de exemplo.
class MenuConfiguracoes extends StatelessWidget {
  const MenuConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Menu()),
              (_) => false,
            ),
          ),
        ],
      ),
      body: _body(context),
    );
  }

  ListView _body(BuildContext ctx) {
    final opcoes = [
      _Opcao("Competição", Icons.emoji_events, () => const TelaAdicionarCompeticao(),
          () => const TelaConsultaCompeticao()),
      _Opcao("Time", Icons.shield, () => const TelaAdicionarTime(),
          () => const TelaConsultaTime()),
      _Opcao("Escola", Icons.school, () => const TelaAdicionarEscola(),
          () => const TelaConsultaEscola()),
      _Opcao("Categoria", Icons.category, () => const TelaAdicionarCategoria(),
          () => const TelaConsultaCategoria()),
      _Opcao("Modalidade", Icons.sports, () => const TelaAdicionarModalidade(),
          () => const TelaConsultaModalidade()),
      _Opcao("Posição", Icons.pan_tool, () => const TelaAdicionarPosicao(),
          () => const TelaConsultaPosicao()),
      _Opcao("Tipo de evento", Icons.flag, () => const TelaAdicionarTipoEvento(),
          () => const TelaConsultaTipoEvento()),
      _Opcao("Evento", Icons.timer, () => const TelaAdicionarEvento(),
          () => const TelaConsultaEvento()),
      _Opcao("Jogador", Icons.person, () => const TelaAdicionarJogador(),
          () => const TelaConsultaJogador()),
      _Opcao("Responsável", Icons.family_restroom, () => const TelaAdicionarResponsavel(),
          () => const TelaConsultaResponsavel()),
      _Opcao("Técnico", Icons.sports, () => const TelaAdicionarTecnico(),
          () => const TelaConsultaTecnico()),
      _Opcao("Documento", Icons.description, () => const TelaAdicionarDocumento(),
          () => const TelaConsultaDocumento()),
      _Opcao("Foto", Icons.image, () => const TelaAdicionarFoto(),
          () => const TelaConsultaFoto()),
      _Opcao("Rodada", Icons.calendar_today, () => const TelaAdicionarRodada(),
          () => const TelaConsultaRodada()),
      _Opcao("Partida", Icons.sports_soccer, () => const TelaAdicionarPartida(),
          () => const TelaConsultaPartida()),
      _Opcao("Inscrição", Icons.assignment, () => const TelaAdicionarParticipacao(),
          () => const TelaConsultaParticipacao()),
      _Opcao("Pagamento", Icons.payments, () => const TelaAdicionarPagamento(),
          () => const TelaConsultaPagamento()),
      _Opcao("Suspensão", Icons.block, () => const TelaAdicionarSuspensao(),
          () => const TelaConsultaSuspensao()),
      _Opcao("Dados exemplo", Icons.science, null, null,
          destinoDireto: () => const TelaDadosExemplo()),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: opcoes.length,
      itemBuilder: (context, index) {
        final opcao = opcoes[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(opcao.icone, size: 32, color: const Color(0xFF0462C3)),
            title: Text(
              opcao.titulo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _abre(ctx, opcao),
          ),
        );
      },
    );
  }

  void _abre(BuildContext ctx, _Opcao opcao) {
    if (opcao.destinoDireto != null) {
      Navigator.push(
        ctx,
        MaterialPageRoute(builder: (_) => opcao.destinoDireto!()),
      );
      return;
    }

    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => TelaDetalheEntidade(
          titulo: opcao.titulo,
          icone: opcao.icone,
          telaCadastro: opcao.abreCadastro!(),
          telaConsulta: opcao.abreConsulta!(),
        ),
      ),
    );
  }
}

class _Opcao {
  final String titulo;
  final IconData icone;
  final Function()? abreCadastro;
  final Function()? abreConsulta;
  final Function()? destinoDireto;

  _Opcao(
    this.titulo,
    this.icone,
    this.abreCadastro,
    this.abreConsulta, {
    this.destinoDireto,
  });
}
