import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_evento.dart';
import 'package:projeto_final/control/control_suspensao.dart';
import 'package:projeto_final/model/evento_partida.dart';
import 'package:projeto_final/model/suspensao.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarSuspensao extends StatefulWidget {
  const TelaAdicionarSuspensao({super.key});

  @override
  State<TelaAdicionarSuspensao> createState() => _TelaAdicionarSuspensaoState();
}

class _TelaAdicionarSuspensaoState extends State<TelaAdicionarSuspensao> {
  final _motivo = TextEditingController();
  final _qtdJogos = TextEditingController();
  String? _idEvento;
  List<EventoPartida> _eventos = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    ControlEvento control = ControlEvento();
    List<EventoPartida> lista = await control.queryFind();
    setState(() {
      _eventos = lista;
      if (lista.isNotEmpty) _idEvento = lista[0].id.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar suspensão"),
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
          value: _idEvento,
          decoration: InputDecoration(
            labelText: "Evento que originou",
            border: OutlineInputBorder(),
          ),
          items: _eventos.map((e) {
            return DropdownMenuItem<String>(
              value: e.id.toString(),
              child: Text("Evento ${e.id} - ${e.minutoEvento}'"),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idEvento = v),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: InputTextos("Motivo", "Informe", controller: _motivo),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InputTextos(
                "Qtd de jogos",
                "1",
                controller: _qtdJogos,
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
    Suspensao suspensao = Suspensao(
      idEvento: int.tryParse(_idEvento ?? "0") ?? 0,
      motivo: _motivo.text,
      qtdJogosSuspensao: int.tryParse(_qtdJogos.text) ?? 1,
    );

    ControlSuspensao control = ControlSuspensao();
    int id = await control.insertDatabase(suspensao);

    setState(() {
      _resultado = "Suspensão registrada! (id: $id)";
    });
  }
}
