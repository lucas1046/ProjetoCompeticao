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
import 'package:projeto_final/telas/tela_detalhe_entidade.dart';

/// Menu de configurações com item para cada entidade.
class MenuConfiguracoes extends StatelessWidget {
  const MenuConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => Menu()),
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
      _Opcao("Competição", Icons.emoji_events, () => TelaAdicionarCompeticao(),
          () => TelaConsultaCompeticao()),
      _Opcao("Time", Icons.shield, () => TelaAdicionarTime(),
          () => TelaConsultaTime()),
      _Opcao("Escola", Icons.school, () => TelaAdicionarEscola(),
          () => TelaConsultaEscola()),
      _Opcao("Categoria", Icons.category, () => TelaAdicionarCategoria(),
          () => TelaConsultaCategoria()),
      _Opcao("Modalidade", Icons.sports, () => TelaAdicionarModalidade(),
          () => TelaConsultaModalidade()),
      _Opcao("Posição", Icons.pan_tool, () => TelaAdicionarPosicao(),
          () => TelaConsultaPosicao()),
      _Opcao("Tipo de evento", Icons.flag, () => TelaAdicionarTipoEvento(),
          () => TelaConsultaTipoEvento()),
      _Opcao("Evento", Icons.timer, () => TelaAdicionarEvento(),
          () => TelaConsultaEvento()),
      _Opcao("Jogador", Icons.person, () => TelaAdicionarJogador(),
          () => TelaConsultaJogador()),
      _Opcao("Responsável", Icons.family_restroom, () => TelaAdicionarResponsavel(),
          () => TelaConsultaResponsavel()),
      _Opcao("Técnico", Icons.sports, () => TelaAdicionarTecnico(),
          () => TelaConsultaTecnico()),
      _Opcao("Documento", Icons.description, () => TelaAdicionarDocumento(),
          () => TelaConsultaDocumento()),
      _Opcao("Foto", Icons.image, () => TelaAdicionarFoto(),
          () => TelaConsultaFoto()),
      _Opcao("Rodada", Icons.calendar_today, () => TelaAdicionarRodada(),
          () => TelaConsultaRodada()),
      _Opcao("Partida", Icons.sports_soccer, () => TelaAdicionarPartida(),
          () => TelaConsultaPartida()),
      _Opcao("Inscrição", Icons.assignment, () => TelaAdicionarParticipacao(),
          () => TelaConsultaParticipacao()),
      _Opcao("Pagamento", Icons.payments, () => TelaAdicionarPagamento(),
          () => TelaConsultaPagamento()),
      _Opcao("Suspensão", Icons.block, () => TelaAdicionarSuspensao(),
          () => TelaConsultaSuspensao()),
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: opcoes.length,
      itemBuilder: (context, index) {
        final opcao = opcoes[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(opcao.icone, size: 32, color: Colors.blue),
            title: Text(
              opcao.titulo,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _abre(ctx, opcao),
          ),
        );
      },
    );
  }

  void _abre(BuildContext ctx, _Opcao opcao) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => TelaDetalheEntidade(
          titulo: opcao.titulo,
          icone: opcao.icone,
          telaCadastro: opcao.abreCadastro(),
          telaConsulta: opcao.abreConsulta(),
        ),
      ),
    );
  }
}

class _Opcao {
  final String titulo;
  final IconData icone;
  final Function() abreCadastro;
  final Function() abreConsulta;

  _Opcao(this.titulo, this.icone, this.abreCadastro, this.abreConsulta);
}