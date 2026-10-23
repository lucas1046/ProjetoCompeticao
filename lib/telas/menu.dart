import 'package:flutter/material.dart';
import 'package:projeto_final/telas/tela_adicionar_categoria.dart';
import 'package:projeto_final/telas/tela_adicionar_competicao.dart';
import 'package:projeto_final/telas/tela_adicionar_documento.dart';
import 'package:projeto_final/telas/tela_adicionar_escalacao.dart';
import 'package:projeto_final/telas/tela_adicionar_escola.dart';
import 'package:projeto_final/telas/tela_adicionar_evento.dart';
import 'package:projeto_final/telas/tela_adicionar_foto.dart';
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

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Competições Escolares"),
        backgroundColor: Colors.blue,
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
      _Opcao("Modalidade", Icons.sports_soccer, () => TelaAdicionarModalidade(),
          () => TelaConsultaModalidade()),
      _Opcao("Categoria", Icons.category, () => TelaAdicionarCategoria(),
          () => TelaConsultaCategoria()),
      _Opcao("Tipo de evento", Icons.flag, () => TelaAdicionarTipoEvento(),
          () => TelaConsultaTipoEvento()),
      _Opcao("Posição", Icons.pan_tool, () => TelaAdicionarPosicao(),
          () => TelaConsultaPosicao()),
      _Opcao("Responsável", Icons.family_restroom,
          () => TelaAdicionarResponsavel(), () => TelaConsultaResponsavel()),
      _Opcao("Jogador", Icons.person, () => TelaAdicionarJogador(),
          () => TelaConsultaJogador()),
      _Opcao("Documento", Icons.description, () => TelaAdicionarDocumento(),
          () => TelaConsultaDocumento()),
      _Opcao("Escola", Icons.school, () => TelaAdicionarEscola(),
          () => TelaConsultaEscola()),
      _Opcao("Técnico", Icons.escalator_warning, () => TelaAdicionarTecnico(),
          () => TelaConsultaTecnico()),
      _Opcao("Time", Icons.groups, () => TelaAdicionarTime(),
          () => TelaConsultaTime()),
      _Opcao("Foto", Icons.photo_camera, () => TelaAdicionarFoto(),
          () => TelaConsultaFoto()),
      _Opcao("Técnico/Time", Icons.link, () => TelaAdicionarTecnicoTime(),
          () => TelaConsultaTecnicoTime()),
      _Opcao("Inscrição", Icons.how_to_reg, () => TelaAdicionarParticipacao(),
          () => TelaConsultaParticipacao()),
      _Opcao("Pagamento", Icons.payments, () => TelaAdicionarPagamento(),
          () => TelaConsultaPagamento()),
      _Opcao("Rodada", Icons.calendar_month, () => TelaAdicionarRodada(),
          () => TelaConsultaRodada()),
      _Opcao("Partida", Icons.sports_score, () => TelaAdicionarPartida(),
          () => TelaConsultaPartida()),
      _Opcao("Escalação", Icons.format_list_numbered,
          () => TelaAdicionarEscalacao(), () => TelaConsultaEscalacao()),
      _Opcao("Evento", Icons.timer, () => TelaAdicionarEvento(),
          () => TelaConsultaEvento()),
      _Opcao("Suspensão", Icons.block, () => TelaAdicionarSuspensao(),
          () => TelaConsultaSuspensao()),
      _Opcao("Relatórios", Icons.assessment, () => Container(),
          () => MenuRelatorios()),
      _Opcao("Dados exemplo", Icons.science, () => Container(),
          () => TelaDadosExemplo()),
    ];

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: opcoes.length,
      itemBuilder: (context, index) {
        final opcao = opcoes[index];
        return Card(
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(opcao.icone, size: 40, color: Colors.blue),
                Text(
                  opcao.titulo,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _abreTelas(ctx, opcao.abreCadastro()),
                          child: Text("Cadastrar", style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _abreTelas(ctx, opcao.abreConsulta()),
                          child: Text("Consultar", style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
}

class _Opcao {
  final String titulo;
  final IconData icone;
  final Function() abreCadastro;
  final Function() abreConsulta;

  _Opcao(this.titulo, this.icone, this.abreCadastro, this.abreConsulta);
}
