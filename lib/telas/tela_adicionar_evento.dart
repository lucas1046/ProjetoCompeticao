import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_escalacao.dart';
import 'package:projeto_final/control/control_evento.dart';
import 'package:projeto_final/control/control_tipo_evento.dart';
import 'package:projeto_final/model/escalacao.dart';
import 'package:projeto_final/model/evento_partida.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarEvento extends StatefulWidget {
  const TelaAdicionarEvento({super.key});

  @override
  State<TelaAdicionarEvento> createState() => _TelaAdicionarEventoState();
}

class _TelaAdicionarEventoState extends State<TelaAdicionarEvento> {
  final _minuto = TextEditingController();
  final _descricao = TextEditingController();
  String? _idTipoEvento;
  String? _idEscalacao;
  List<TipoEvento> _tipos = [];
  List<Escalacao> _escalacoes = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    ControlTipoEvento controlTipo = ControlTipoEvento();
    ControlEscalacao controlEscalacao = ControlEscalacao();

    List<TipoEvento> tipos = await controlTipo.queryFind();
    List<Escalacao> escalacoes = await controlEscalacao.queryFind();

    setState(() {
      _tipos = tipos;
      _escalacoes = escalacoes;
      if (tipos.isNotEmpty) _idTipoEvento = tipos[0].id.toString();
      if (escalacoes.isNotEmpty) _idEscalacao = escalacoes[0].id.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar evento de partida"),
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

  ListView _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          initialValue: _idEscalacao,
          decoration: InputDecoration(
            labelText: "Jogador escalado",
            border: OutlineInputBorder(),
          ),
          items: _escalacoes.map((e) {
            return DropdownMenuItem<String>(
              value: e.id.toString(),
              child: Text("Escalação ${e.id} - jogador ${e.idJogador}"),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idEscalacao = v),
        ),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _idTipoEvento,
          decoration: InputDecoration(
            labelText: "Tipo de evento",
            border: OutlineInputBorder(),
          ),
          items: _tipos.map((t) {
            return DropdownMenuItem<String>(
              value: t.id.toString(),
              child: Text(t.descricao),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idTipoEvento = v),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InputTextos(
                "Minuto",
                "Informe o minuto",
                controller: _minuto,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: InputTextos("Descrição", "Informe", controller: _descricao),
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
    EventoPartida evento = EventoPartida(
      idTipoEvento: int.tryParse(_idTipoEvento ?? "0") ?? 0,
      minutoEvento: int.tryParse(_minuto.text) ?? 0,
      descricao: _descricao.text,
      idEscalacao: int.tryParse(_idEscalacao ?? "0") ?? 0,
    );

    try {
      ControlEvento control = ControlEvento();
      int id = await control.insertDatabase(evento);

      setState(() {
    _resultado = "Evento registrado! (id: $id)";
      });
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
