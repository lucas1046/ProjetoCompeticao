import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_escalacao.dart';
import 'package:projeto_final/control/control_partida.dart';
import 'package:projeto_final/control/control_participacao.dart';
import 'package:projeto_final/control/control_posicao.dart';
import 'package:projeto_final/model/escalacao.dart';
import 'package:projeto_final/model/partida.dart';
import 'package:projeto_final/model/participacao_jogador_time.dart';
import 'package:projeto_final/model/posicao.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarEscalacao extends StatefulWidget {
  const TelaAdicionarEscalacao({super.key});

  @override
  State<TelaAdicionarEscalacao> createState() => _TelaAdicionarEscalacaoState();
}

class _TelaAdicionarEscalacaoState extends State<TelaAdicionarEscalacao> {
  final _numeroCamisa = TextEditingController();
  String? _idPartida;
  String? _idPosicao;
  String? _idParticipacao;
  String _titular = "Titular";
  List<Partida> _partidas = [];
  List<Posicao> _posicoes = [];
  List<ParticipacaoJogadorTime> _participacoes = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    ControlPartida controlPartida = ControlPartida();
    ControlPosicao controlPosicao = ControlPosicao();
    ControlParticipacao controlParticipacao = ControlParticipacao();

    List<Partida> partidas = await controlPartida.queryFind();
    List<Posicao> posicoes = await controlPosicao.queryFind();
    List<ParticipacaoJogadorTime> participacoes =
        await controlParticipacao.queryFind();

    setState(() {
      _partidas = partidas;
      _posicoes = posicoes;
      _participacoes = participacoes;
      if (partidas.isNotEmpty) _idPartida = partidas[0].id.toString();
      if (posicoes.isNotEmpty) _idPosicao = posicoes[0].id.toString();
      if (participacoes.isNotEmpty) {
        _idParticipacao = participacoes[0].id.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar escalação"),
        backgroundColor: Colors.green,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          value: _idPartida,
          decoration: InputDecoration(
            labelText: "Partida",
            border: OutlineInputBorder(),
          ),
          items: _partidas.map((p) {
            return DropdownMenuItem<String>(
              value: p.id.toString(),
              child: Text("Partida ${p.id}"),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idPartida = v),
        ),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _idParticipacao,
          decoration: InputDecoration(
            labelText: "Jogador inscrito",
            border: OutlineInputBorder(),
          ),
          items: _participacoes.map((p) {
            return DropdownMenuItem<String>(
              value: p.id.toString(),
              child: Text("Inscrição ${p.id} - camisa ${p.numeroCamisa}"),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idParticipacao = v),
        ),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _idPosicao,
          decoration: InputDecoration(
            labelText: "Posição",
            border: OutlineInputBorder(),
          ),
          items: _posicoes.map((p) {
            return DropdownMenuItem<String>(
              value: p.id.toString(),
              child: Text(p.nome),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idPosicao = v),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InputTextos(
                "Número da camisa",
                "Informe o número",
                controller: _numeroCamisa,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _titular,
                decoration: InputDecoration(
                  labelText: "Condição",
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: "Titular", child: Text("Titular")),
                  DropdownMenuItem(value: "Suplente", child: Text("Suplente")),
                ],
                onChanged: (v) => setState(() => _titular = v ?? "Titular"),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    Escalacao escalacao = Escalacao(
      idPartida: int.tryParse(_idPartida ?? "0") ?? 0,
      titular: _titular,
      numeroCamisa: int.tryParse(_numeroCamisa.text) ?? 0,
      idPosicao: int.tryParse(_idPosicao ?? "0") ?? 0,
      idParticipacao: int.tryParse(_idParticipacao ?? "0") ?? 0,
    );

    ControlEscalacao control = ControlEscalacao();
    int id = await control.insertDatabase(escalacao);

    setState(() {
      _resultado = "Escalação registrada! (id: $id)";
    });
  }
}
