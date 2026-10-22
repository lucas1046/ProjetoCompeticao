import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/control/control_participacao.dart';
import 'package:projeto_final/control/control_time.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/model/participacao_jogador_time.dart';
import 'package:projeto_final/model/time.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarParticipacao extends StatefulWidget {
  const TelaAdicionarParticipacao({super.key});

  @override
  State<TelaAdicionarParticipacao> createState() =>
      _TelaAdicionarParticipacaoState();
}

class _TelaAdicionarParticipacaoState extends State<TelaAdicionarParticipacao> {
  final _numeroCamisa = TextEditingController();
  final _valorInscricao = TextEditingController();
  String? _idJogador;
  String? _idTime;
  List<Jogador> _jogadores = [];
  List<Time> _times = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    ControlJogador controlJogador = ControlJogador();
    ControlTime controlTime = ControlTime();

    List<Jogador> jogadores = await controlJogador.queryFind();
    List<Time> times = await controlTime.queryFind();

    setState(() {
      _jogadores = jogadores;
      _times = times;
      if (jogadores.isNotEmpty) _idJogador = jogadores[0].id.toString();
      if (times.isNotEmpty) _idTime = times[0].idTime.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inscrever jogador no time"),
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
          value: _idJogador,
          decoration: InputDecoration(
            labelText: "Jogador",
            border: OutlineInputBorder(),
          ),
          items: _jogadores.map((j) {
            return DropdownMenuItem<String>(
              value: j.id.toString(),
              child: Text(j.nome),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idJogador = v),
        ),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _idTime,
          decoration: InputDecoration(
            labelText: "Time",
            border: OutlineInputBorder(),
          ),
          items: _times.map((t) {
            return DropdownMenuItem<String>(
              value: t.idTime.toString(),
              child: Text(t.nomeTime),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idTime = v),
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
              child: InputTextos(
                "Valor da inscrição",
                "0.00",
                controller: _valorInscricao,
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
    ParticipacaoJogadorTime participacao = ParticipacaoJogadorTime(
      idJogador: int.tryParse(_idJogador ?? "0") ?? 0,
      idTime: int.tryParse(_idTime ?? "0") ?? 0,
      numeroCamisa: int.tryParse(_numeroCamisa.text),
      valorInscricao: double.tryParse(_valorInscricao.text),
    );

    ControlParticipacao control = ControlParticipacao();
    int id = await control.insertDatabase(participacao);

    setState(() {
      _resultado = "Inscrição cadastrada! (id: $id)";
    });
  }
}
