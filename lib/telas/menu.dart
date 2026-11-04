import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_sessao.dart';
import 'package:projeto_final/telas/tela_adicionar_categoria.dart';
import 'package:projeto_final/telas/tela_adicionar_competicao.dart';
import 'package:projeto_final/telas/tela_adicionar_documento.dart';
import 'package:projeto_final/telas/tela_adicionar_evento.dart';
import 'package:projeto_final/telas/tela_adicionar_escola.dart';
import 'package:projeto_final/telas/tela_adicionar_jogador.dart';
import 'package:projeto_final/telas/tela_adicionar_modalidade.dart';
import 'package:projeto_final/telas/tela_adicionar_pagamento.dart';
import 'package:projeto_final/telas/tela_adicionar_participacao.dart';
import 'package:projeto_final/telas/tela_adicionar_partida.dart';
import 'package:projeto_final/telas/tela_adicionar_posicao.dart';
import 'package:projeto_final/telas/tela_adicionar_responsavel.dart';
import 'package:projeto_final/telas/tela_adicionar_rodada.dart';
import 'package:projeto_final/telas/tela_adicionar_suspensao.dart';
import 'package:projeto_final/telas/tela_adicionar_tecnico.dart';
import 'package:projeto_final/telas/tela_adicionar_tecnico_time.dart';
import 'package:projeto_final/telas/tela_adicionar_time.dart';
import 'package:projeto_final/telas/tela_adicionar_tipo_evento.dart';
import 'package:projeto_final/telas/tela_dados_exemplo.dart';
import 'package:projeto_final/telas/tela_menu_configuracoes.dart';
import 'package:projeto_final/telas/tela_menu_relatorios.dart';
import 'package:projeto_final/telas/tela_consulta_categoria.dart';
import 'package:projeto_final/telas/tela_consulta_competicao.dart';
import 'package:projeto_final/telas/tela_consulta_documento.dart';
import 'package:projeto_final/telas/tela_consulta_escalacao.dart';
import 'package:projeto_final/telas/tela_consulta_escola.dart';
import 'package:projeto_final/telas/tela_consulta_evento.dart';
import 'package:projeto_final/telas/tela_consulta_foto.dart';
import 'package:projeto_final/telas/tela_consulta_jogador.dart';
import 'package:projeto_final/telas/tela_consulta_modalidade.dart';
import 'package:projeto_final/telas/tela_consulta_pagamento.dart';
import 'package:projeto_final/telas/tela_consulta_participacao.dart';
import 'package:projeto_final/telas/tela_consulta_partida.dart';
import 'package:projeto_final/telas/tela_consulta_posicao.dart';
import 'package:projeto_final/telas/tela_consulta_responsavel.dart';
import 'package:projeto_final/telas/tela_consulta_rodada.dart';
import 'package:projeto_final/telas/tela_consulta_suspensao.dart';
import 'package:projeto_final/telas/tela_consulta_tecnico.dart';
import 'package:projeto_final/telas/tela_consulta_tecnico_time.dart';
import 'package:projeto_final/telas/tela_consulta_time.dart';
import 'package:projeto_final/telas/tela_consulta_tipo_evento.dart';
import 'package:projeto_final/telas/tela_busca_global.dart';
import 'package:projeto_final/telas/tela_auditoria.dart';
import 'package:projeto_final/telas/tela_detalhe_entidade.dart';
import 'package:projeto_final/telas/tela_login.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Competições Escolares"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            tooltip: "Busca global",
            icon: Icon(Icons.search),
            onPressed: () => _abreTelas(context, TelaBuscaGlobal()),
          ),
          IconButton(
            tooltip: "Sair",
            icon: Icon(Icons.logout),
            onPressed: () => _sair(context),
          ),
        ],
      ),
      body: _body(context),
    );
  }

  _body(BuildContext ctx) {
    return Column(
      children: [
        Card(
          color: Colors.purple,
          margin: EdgeInsets.all(16),
          child: ListTile(
            leading: Icon(Icons.assessment, size: 36, color: Colors.white),
            title: Text(
              "Relatórios e estatísticas",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "Classificação, financeiro, partidas e suspensões",
              style: TextStyle(color: Colors.white70),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.white),
            onTap: () => _abreTelas(ctx, MenuRelatorios()),
          ),
        ),
        Expanded(child: _grid(ctx)),
      ],
    );
  }

  _grid(BuildContext ctx) {
    final opcoes = [
      _Opcao("Competição", Icons.emoji_events, () => TelaAdicionarCompeticao(),
          () => TelaConsultaCompeticao()),
      _Opcao("Jogador", Icons.person, () => TelaAdicionarJogador(),
          () => TelaConsultaJogador()),
      _Opcao("Documento", Icons.description, () => TelaAdicionarDocumento(),
          () => TelaConsultaDocumento(),
          soAdministrador: true),
      _Opcao("Time", Icons.groups, () => TelaAdicionarTime(),
          () => TelaConsultaTime()),
      _Opcao("Pagamento", Icons.payments, () => TelaAdicionarPagamento(),
          () => TelaConsultaPagamento()),
      _Opcao("Partida", Icons.sports_score, () => TelaAdicionarPartida(),
          () => TelaConsultaPartida()),
      _Opcao("Suspensão", Icons.block, () => TelaAdicionarSuspensao(),
          () => TelaConsultaSuspensao()),
      _Opcao("Relatórios", Icons.assessment, null, null,
          destinoDireto: () => MenuRelatorios()),
      _Opcao("Configurações", Icons.settings, null, null,
          destinoDireto: () => MenuConfiguracoes()),
      _Opcao("Dados exemplo", Icons.science, null, null,
          destinoDireto: () => TelaDadosExemplo()),
      _Opcao("Auditoria", Icons.history, null, null,
          destinoDireto: () => TelaAuditoria(), soAdministrador: true),
    ];

    final opcoesVisiveis = opcoes
        .where((o) => !o.soAdministrador || ControlSessao().isAdministrador)
        .toList();

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: opcoesVisiveis.length,
      itemBuilder: (context, index) {
        final opcao = opcoesVisiveis[index];
        return Card(
          elevation: 3,
          child: InkWell(
            onTap: () => _aoToqueCard(ctx, opcao),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(opcao.icone, size: 36, color: Colors.blue),
                  SizedBox(height: 8),
                  Text(
                    opcao.titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _aoToqueCard(BuildContext ctx, _Opcao opcao) {
    if (opcao.destinoDireto != null) {
      _abreTelas(ctx, opcao.destinoDireto!());
      return;
    }

    _abreTelas(
      ctx,
      TelaDetalheEntidade(
        titulo: opcao.titulo,
        icone: opcao.icone,
        telaCadastro: opcao.abreCadastro!(),
        telaConsulta: opcao.abreConsulta!(),
      ),
    );
  }

  _abreTelas(ctx, page) {
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }),
    );
  }

  _sair(BuildContext ctx) {
    ControlSessao().sair();
    Navigator.pushReplacement(
      ctx,
      MaterialPageRoute(builder: (BuildContext context) => TelaLogin()),
    );
  }
}

class _Opcao {
  final String titulo;
  final IconData icone;
  final Function()? abreCadastro;
  final Function()? abreConsulta;
  final bool soAdministrador;
  final Function()? destinoDireto;

  _Opcao(
    this.titulo,
    this.icone,
    this.abreCadastro,
    this.abreConsulta, {
    this.soAdministrador = false,
    this.destinoDireto,
  });
}
