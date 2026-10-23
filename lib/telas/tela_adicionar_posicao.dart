import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_modalidade.dart';
import 'package:projeto_final/control/control_posicao.dart';
import 'package:projeto_final/model/modalidade.dart';
import 'package:projeto_final/model/posicao.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarPosicao extends StatefulWidget {
  const TelaAdicionarPosicao({super.key});

  @override
  State<TelaAdicionarPosicao> createState() => _TelaAdicionarPosicaoState();
}

class _TelaAdicionarPosicaoState extends State<TelaAdicionarPosicao> {
  final _nome = TextEditingController();
  String? _idModalidadeSelecionada;
  List<Modalidade> _modalidades = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarModalidades();
  }

  Future<void> _carregarModalidades() async {
    ControlModalidade control = ControlModalidade();
    List<Modalidade> lista = await control.queryFind();
    setState(() {
      _modalidades = lista;
      if (lista.isNotEmpty) {
        _idModalidadeSelecionada = lista[0].id.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar posição"),
        backgroundColor: Colors.green,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos("Digite o nome", "Ex: Goleiro, Zagueiro", controller: _nome),
        DropdownButtonFormField<String>(
          value: _idModalidadeSelecionada,
          decoration: InputDecoration(
            labelText: "Modalidade",
            border: OutlineInputBorder(),
          ),
          items: _modalidades.map((m) {
            return DropdownMenuItem<String>(
              value: m.id.toString(),
              child: Text(m.nome),
            );
          }).toList(),
          onChanged: (valor) {
            setState(() {
              _idModalidadeSelecionada = valor;
            });
          },
        ),
        SizedBox(height: 16),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    Posicao posicao = Posicao(
      nome: _nome.text,
      idModalidade: int.tryParse(_idModalidadeSelecionada ?? "0") ?? 0,
    );

    try {
      ControlPosicao control = ControlPosicao();
      int id = await control.insertDatabase(posicao);

      setState(() {
    _resultado = "Posição ${posicao.nome} cadastrada! (id: $id)";
      });
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
