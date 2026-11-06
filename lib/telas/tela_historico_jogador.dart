import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/util/gerador_pdf.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

/// Histórico completo de um jogador: participações, partidas, eventos e suspensões.
class TelaHistoricoJogador extends StatefulWidget {
  final int idJogador;
  final String nomeJogador;

  const TelaHistoricoJogador({
    super.key,
    required this.idJogador,
    required this.nomeJogador,
  });

  @override
  State<TelaHistoricoJogador> createState() => _TelaHistoricoJogadorState();
}

class _TelaHistoricoJogadorState extends State<TelaHistoricoJogador> {
  Map<String, dynamic> _dados = {};
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      final d = await ControlJogador().historicoJogador(widget.idJogador);
      if (mounted) setState(() { _dados = d; _carregando = false; });
    } catch (_) {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _gerarFicha() async {
    try {
      final j = _dados['jogador'] as Map<String, dynamic>? ?? {};
      final part = (_dados['participacoes'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final pags = _dados['pagamentos'] as Map? ?? {};
      final pagamentos = <int, List<Map<String, dynamic>>>{};
      pags.forEach((k, v) {
        pagamentos[k as int] = (v as List).cast<Map<String, dynamic>>();
      });

      final bytes = await GeradorPdf().fichaJogador(j, part, pagamentos);
      await GeradorPdf().compartilhar(bytes, "ficha_${j['nome'] ?? 'jogador'}.pdf");
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao gerar ficha: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico: ${widget.nomeJogador}"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            tooltip: "Gerar ficha PDF",
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _gerarFicha,
          ),
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
      body: _carregando
          ? Center(child: CircularProgressIndicator())
          : _body(),
    );
  }

  ListView _body() {
    final j = _dados['jogador'] as Map<String, dynamic>? ?? {};
    final part = _dados['participacoes'] as List? ?? [];
    final pags = _dados['pagamentos'] as Map? ?? {};
    final partidas = _dados['partidas'] as List? ?? [];
    final eventos = _dados['eventos'] as List? ?? [];
    final susp = _dados['suspensoes'] as List? ?? [];

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Dados do jogador
        CartaoConsulta(
          j['nome'] ?? "-",
          [
            "CPF: ${j['cpf'] ?? '-'}",
            "Nascimento: ${j['data_nascimento'] ?? '-'}",
            "Responsável: ${j['nomeResponsavel'] ?? '-'}",
          ],
          icone: Icons.person,
        ),
        SizedBox(height: 16),

        // Participações
        if (part.isNotEmpty) ...[
          Text("Participações (times)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ...part.map((p) {
            int id = p['id'] as int;
            List pgs = (pags[id] as List?) ?? [];
            double pago = pgs.fold(0.0, (s, pg) => s + ((pg['valor_pago'] as num?)?.toDouble() ?? 0));
            double insc = (p['valor_inscricao'] as num?)?.toDouble() ?? 0;
            return CartaoConsulta(
              p['nome_time'] ?? "-",
              [
                "Escola: ${p['nomeEscola']}",
                "Camisa: ${p['numero_camisa'] ?? '-'}",
                "Inscrição: R\$ ${insc.toStringAsFixed(2)} - Pago: R\$ ${pago.toStringAsFixed(2)}",
              ],
              icone: Icons.groups,
            );
          }),
          SizedBox(height: 16),
        ],

        // Partidas
        if (partidas.isNotEmpty) ...[
          Text("Partidas jogadas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ...partidas.map((p) => CartaoConsulta(
                "${p['timeCasa']} ${p['qtd_gols_time_casa']} x ${p['qtd_gols_time_visitante']} ${p['timeVisitante']}",
                [
                  "${p['nomeCompeticao']} - Rodada ${p['numeroRodada']}",
                  "Data: ${p['dataRodada']}",
                  "Posição: ${p['nomePosicao']} - ${p['titular'] == 'titular' ? 'Titular' : 'Reserva'} - Camisa ${p['numero_camisa']}",
                ],
                icone: Icons.sports_score,
              )),
          SizedBox(height: 16),
        ],

        // Eventos
        if (eventos.isNotEmpty) ...[
          Text("Eventos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ...eventos.map((e) => CartaoConsulta(
                e['tipoEvento'] ?? "-",
                [
                  "Minuto: ${e['minuto_evento']}",
                  if (e['descricao'] != null && (e['descricao'] as String).isNotEmpty) e['descricao'],
                ],
                icone: Icons.timer,
              )),
          SizedBox(height: 16),
        ],

        // Suspensões
        if (susp.isNotEmpty) ...[
          Text("Suspensões", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ...susp.map((s) => CartaoConsulta(
                s['motivo'] ?? "-",
                [
                  "${s['tipoEvento']} - Minuto ${s['minuto_evento']}",
                  "${s['qtd_jogos_suspensao']} jogo(s) - ${s['cumprida'] == 1 ? 'Cumprida' : 'Em aberto'}",
                ],
                icone: Icons.block,
              )),
        ],

        if (part.isEmpty && partidas.isEmpty && eventos.isEmpty && susp.isEmpty)
          TextosCustom("Nenhum histórico encontrado para este jogador.", 16, Colors.grey),
      ],
    );
  }
}
