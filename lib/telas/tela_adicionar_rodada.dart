import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_competicao.dart';
import 'package:projeto_final/control/control_rodada.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:projeto_final/model/rodada.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';
import 'package:projeto_final/util/formatador.dart';

class TelaAdicionarRodada extends StatefulWidget {
  const TelaAdicionarRodada({super.key});

  @override
  State<TelaAdicionarRodada> createState() => _TelaAdicionarRodadaState();
}

class _TelaAdicionarRodadaState extends State<TelaAdicionarRodada> {
  final _numero = TextEditingController();
  final _data = TextEditingController();
  String? _idCompeticao;
  List<Competicao> _competicoes = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarCompeticoes();
  }

  Future<void> _carregarCompeticoes() async {
    ControlCompeticao control = ControlCompeticao();
    List<Competicao> lista = await control.queryFind();
    setState(() {
      _competicoes = lista;
      if (lista.isNotEmpty) _idCompeticao = lista[0].id.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar rodada"),
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
          initialValue: _idCompeticao,
          decoration: InputDecoration(
            labelText: "Competição",
            border: OutlineInputBorder(),
          ),
          items: _competicoes.map((c) {
            return DropdownMenuItem<String>(
              value: c.id.toString(),
              child: Text(c.nome),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idCompeticao = v),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InputTextos(
                "Número da rodada",
                "Informe o número",
                controller: _numero,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InputTextos(
                "Data",
                "dd/MM/yyyy",
                controller: _data,
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
    Rodada rodada = Rodada(
      numero: int.tryParse(_numero.text) ?? 0,
      data: Formatador.dataIso(_data.text),
      idCompeticao: int.tryParse(_idCompeticao ?? "0") ?? 0,
    );

    try {
      ControlRodada control = ControlRodada();
      int id = await control.insertDatabase(rodada);

      setState(() {
    _resultado = "Rodada ${rodada.numero} cadastrada! (id: $id)";
      });
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
