import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_sessao.dart';
import 'package:projeto_final/telas/tela_adicionar_competicao.dart';
import 'package:projeto_final/telas/tela_adicionar_documento.dart';
import 'package:projeto_final/telas/tela_adicionar_jogador.dart';
import 'package:projeto_final/telas/tela_adicionar_pagamento.dart';
import 'package:projeto_final/telas/tela_adicionar_participacao.dart';
import 'package:projeto_final/telas/tela_adicionar_partida.dart';
import 'package:projeto_final/telas/tela_adicionar_suspensao.dart';
import 'package:projeto_final/telas/tela_adicionar_time.dart';
import 'package:projeto_final/telas/tela_menu_configuracoes.dart';
import 'package:projeto_final/telas/tela_menu_relatorios.dart';
import 'package:projeto_final/telas/tela_consulta_competicao.dart';
import 'package:projeto_final/telas/tela_consulta_documento.dart';
import 'package:projeto_final/telas/tela_consulta_jogador.dart';
import 'package:projeto_final/telas/tela_consulta_pagamento.dart';
import 'package:projeto_final/telas/tela_consulta_participacao.dart';
import 'package:projeto_final/telas/tela_consulta_partida.dart';
import 'package:projeto_final/telas/tela_consulta_suspensao.dart';
import 'package:projeto_final/telas/tela_consulta_time.dart';
import 'package:projeto_final/telas/tela_detalhe_entidade.dart';
import 'package:projeto_final/telas/tela_login.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  static const Color _corDominante = Color(0xFFF31A2E);
  static const Color _corSecundaria = Color(0xFF0462C3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Competições Escolares"),
        backgroundColor: _corDominante,
        actions: [
          IconButton(
            tooltip: "Sair",
            icon: const Icon(Icons.logout),
            onPressed: () => _sair(context),
          ),
        ],
      ),
      body: _body(context),
    );
  }

  Column _body(BuildContext ctx) {
    return Column(
      children: [
        Card(
          color: _corDominante,
          margin: const EdgeInsets.all(16),
          child: ListTile(
            leading: const Icon(Icons.assessment, size: 36, color: Colors.white),
            title: const Text(
              "Relatórios e estatísticas",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "Classificação, financeiro, partidas e suspensões",
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white),
            onTap: () => _abreTelas(ctx, const MenuRelatorios()),
          ),
        ),
        Expanded(child: _grid(ctx)),
      ],
    );
  }

  GridView _grid(BuildContext ctx) {
    final opcoes = [
      _Opcao("Competição", Icons.emoji_events, () => const TelaAdicionarCompeticao(),
          () => const TelaConsultaCompeticao()),
      _Opcao("Jogador", Icons.person, () => const TelaAdicionarJogador(),
          () => const TelaConsultaJogador()),
      _Opcao("Documento", Icons.description, () => const TelaAdicionarDocumento(),
          () => const TelaConsultaDocumento(),
          soAdministrador: true),
      _Opcao("Time", Icons.groups, () => const TelaAdicionarTime(),
          () => const TelaConsultaTime()),
      _Opcao("Inscrição", Icons.assignment, () => const TelaAdicionarParticipacao(),
          () => const TelaConsultaParticipacao()),
      _Opcao("Pagamento", Icons.payments, () => const TelaAdicionarPagamento(),
          () => const TelaConsultaPagamento()),
      _Opcao("Partida", Icons.sports_score, () => const TelaAdicionarPartida(),
          () => const TelaConsultaPartida()),
      _Opcao("Suspensão", Icons.block, () => const TelaAdicionarSuspensao(),
          () => const TelaConsultaSuspensao()),
      _Opcao("Configurações", Icons.settings, null, null,
          destinoDireto: () => const MenuConfiguracoes()),
    ];

    final opcoesVisiveis = opcoes
        .where((o) => !o.soAdministrador || ControlSessao().isAdministrador)
        .toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(opcao.icone, size: 36, color: _corSecundaria),
                  const SizedBox(height: 8),
                  Text(
                    opcao.titulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _aoToqueCard(BuildContext ctx, _Opcao opcao) {
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

  void _abreTelas(ctx, page) {
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }),
    );
  }

  void _sair(BuildContext ctx) {
    ControlSessao().sair();
    Navigator.pushReplacement(
      ctx,
      MaterialPageRoute(builder: (BuildContext context) => const TelaLogin()),
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
