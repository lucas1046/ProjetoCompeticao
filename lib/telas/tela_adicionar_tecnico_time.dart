import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_tecnico.dart';
import 'package:projeto_final/control/control_tecnico_time.dart';
import 'package:projeto_final/control/control_time.dart';
import 'package:projeto_final/model/tecnico.dart';
import 'package:projeto_final/model/tecnico_time.dart';
import 'package:projeto_final/model/time.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarTecnicoTime extends StatefulWidget {
  const TelaAdicionarTecnicoTime({super.key});

  @override
  State<TelaAdicionarTecnicoTime> createState() =>
      _TelaAdicionarTecnicoTimeState();
}

class _TelaAdicionarTecnicoTimeState extends State<TelaAdicionarTecnicoTime> {
  String? _idTecnico;
  String? _idTime;
  List<Tecnico> _tecnicos = [];
  List<Time> _times = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    ControlTecnico controlTecnico = ControlTecnico();
    ControlTime controlTime = ControlTime();

    List<Tecnico> tecnicos = await controlTecnico.queryFind();
    List<Time> times = await controlTime.queryFind();

    setState(() {
      _tecnicos = tecnicos;
      _times = times;
      if (tecnicos.isNotEmpty) _idTecnico = tecnicos[0].id.toString();
      if (times.isNotEmpty) _idTime = times[0].idTime.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vincular técnico ao time"),
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
          value: _idTecnico,
          decoration: InputDecoration(
            labelText: "Técnico",
            border: OutlineInputBorder(),
          ),
          items: _tecnicos.map((t) {
            return DropdownMenuItem<String>(
              value: t.id.toString(),
              child: Text(t.nome),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idTecnico = v),
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
        SizedBox(height: 16),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    TecnicoTime tecnicoTime = TecnicoTime(
      idTecnico: int.tryParse(_idTecnico ?? "0") ?? 0,
      idTime: int.tryParse(_idTime ?? "0") ?? 0,
    );

    try {
      ControlTecnicoTime control = ControlTecnicoTime();
      int id = await control.insertDatabase(tecnicoTime);

      setState(() {
    _resultado = "Vínculo técnico/time cadastrado! (id: $id)";
      });
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
