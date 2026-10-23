import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_sessao.dart';
import 'package:projeto_final/telas/tela_classificacao.dart';
import 'package:projeto_final/telas/tela_estatisticas_jogador.dart';
import 'package:projeto_final/telas/tela_relatorio_financeiro.dart';
import 'package:projeto_final/telas/tela_relatorio_partidas.dart';
import 'package:projeto_final/telas/tela_relatorio_suspensos.dart';

/// Menu de relatórios e estatísticas (RF-14 e RF-15).
class MenuRelatorios extends StatelessWidget {
  const MenuRelatorios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatórios e estatísticas"),
        backgroundColor: Colors.purple,
      ),
      body: _body(context),
    );
  }

  _body(BuildContext ctx) {
    // RNFR-15.2 — o relatório financeiro só aparece para administradores
    final opcoes = [
      _Relatorio("Estatísticas do jogador", Icons.person_search,
          () => TelaEstatisticasJogador()),
      _Relatorio("Classificação geral", Icons.leaderboard,
          () => TelaClassificacao()),
      _Relatorio("Histórico de partidas", Icons.history,
          () => TelaRelatorioPartidas()),
      _Relatorio("Jogadores suspensos", Icons.block,
          () => TelaRelatorioSuspensos()),
      if (ControlSessao().isAdministrador)
        _Relatorio("Relatório financeiro", Icons.attach_money,
            () => TelaRelatorioFinanceiro()),
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
            leading: Icon(opcao.icone, size: 32, color: Colors.purple),
            title: Text(
              opcao.titulo,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _abreTela(ctx, opcao.abre()),
          ),
        );
      },
    );
  }

  _abreTela(ctx, page) {
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }),
    );
  }
}

class _Relatorio {
  final String titulo;
  final IconData icone;
  final Function() abre;

  _Relatorio(this.titulo, this.icone, this.abre);
}
