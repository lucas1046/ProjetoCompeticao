import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_partida.dart';
import 'package:projeto_final/control/control_rodada.dart';
import 'package:projeto_final/control/control_time.dart';
import 'package:projeto_final/model/partida.dart';
import 'package:projeto_final/model/rodada.dart';
import 'package:projeto_final/model/time.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarPartida extends StatefulWidget {
  const TelaAdicionarPartida({super.key});

  @override
  State<TelaAdicionarPartida> createState() => _TelaAdicionarPartidaState();
}

class _TelaAdicionarPartidaState extends State<TelaAdicionarPartida> {
  final _golsCasa = TextEditingController();
  final _golsVisitante = TextEditingController();
  String? _idRodada;
  String? _idTimeCasa;
  String? _idTimeVisitante;
  bool _wo = false;
  List<Rodada> _rodadas = [];
  List<Time> _times = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    ControlRodada controlRodada = ControlRodada();
    ControlTime controlTime = ControlTime();

    List<Rodada> rodadas = await controlRodada.queryFind();
    List<Time> times = await controlTime.queryFind();

    setState(() {
      _rodadas = rodadas;
      _times = times;
      if (rodadas.isNotEmpty) _idRodada = rodadas[0].id.toString();
      if (times.isNotEmpty) {
        _idTimeCasa = times[0].idTime.toString();
        if (times.length > 1) {
          _idTimeVisitante = times[1].idTime.toString();
        } else {
          _idTimeVisitante = times[0].idTime.toString();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar partida"),
        backgroundColor: Colors.green,
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
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          value: _idRodada,
          decoration: InputDecoration(
            labelText: "Rodada",
            border: OutlineInputBorder(),
          ),
          items: _rodadas.map((r) {
            return DropdownMenuItem<String>(
              value: r.id.toString(),
              child: Text("Rodada ${r.numero}"),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idRodada = v),
        ),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _idTimeCasa,
          decoration: InputDecoration(
            labelText: "Time da casa",
            border: OutlineInputBorder(),
          ),
          items: _times.map((t) {
            return DropdownMenuItem<String>(
              value: t.idTime.toString(),
              child: Text(t.nomeTime),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idTimeCasa = v),
        ),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _idTimeVisitante,
          decoration: InputDecoration(
            labelText: "Time visitante",
            border: OutlineInputBorder(),
          ),
          items: _times.map((t) {
            return DropdownMenuItem<String>(
              value: t.idTime.toString(),
              child: Text(t.nomeTime),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idTimeVisitante = v),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InputTextos(
                "Gols do time da casa",
                "0",
                controller: _golsCasa,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InputTextos(
                "Gols do visitante",
                "0",
                controller: _golsVisitante,
              ),
            ),
          ],
        ),
        CheckboxListTile(
          title: Text("WO (W.O.)"),
          value: _wo,
          onChanged: (v) => setState(() => _wo = v ?? false),
        ),
        SizedBox(height: 8),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    Partida partida = Partida(
      idRodada: int.tryParse(_idRodada ?? "0") ?? 0,
      idTimeCasa: int.tryParse(_idTimeCasa ?? "0") ?? 0,
      idTimeVisitante: int.tryParse(_idTimeVisitante ?? "0") ?? 0,
      qtdGolsTimeCasa: int.tryParse(_golsCasa.text) ?? 0,
      qtdGolsTimeVisitante: int.tryParse(_golsVisitante.text) ?? 0,
      wo: _wo,
    );

    try {
      ControlPartida control = ControlPartida();
      int id = await control.insertDatabase(partida);

      setState(() {
    _resultado = "Partida registrada! (id: $id)";
      });
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
