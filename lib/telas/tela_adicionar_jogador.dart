import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/control/control_responsavel.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/model/responsavel.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarJogador extends StatefulWidget {
  const TelaAdicionarJogador({super.key});

  @override
  State<TelaAdicionarJogador> createState() => _TelaAdicionarJogadorState();
}

class _TelaAdicionarJogadorState extends State<TelaAdicionarJogador> {
  final _nome = TextEditingController();
  final _cpf = TextEditingController();
  final _dataNascimento = TextEditingController();
  String? _idResponsavelSelecionado;
  List<Responsavel> _responsaveis = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarResponsaveis();
  }

  Future<void> _carregarResponsaveis() async {
    ControlResponsavel control = ControlResponsavel();
    List<Responsavel> lista = await control.queryFind();
    setState(() {
      _responsaveis = lista;
      if (lista.isNotEmpty) {
        _idResponsavelSelecionado = lista[0].id.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar jogador"),
        backgroundColor: Colors.green,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos("Digite o nome", "Informe o nome", controller: _nome),
        Row(
          children: [
            Expanded(
              child: InputTextos("Digite o CPF", "Informe o CPF", controller: _cpf),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InputTextos(
                "Data de nascimento",
                "AAAA-MM-DD",
                controller: _dataNascimento,
              ),
            ),
          ],
        ),
        DropdownButtonFormField<String>(
          value: _idResponsavelSelecionado,
          decoration: InputDecoration(
            labelText: "Responsável legal",
            border: OutlineInputBorder(),
          ),
          items: _responsaveis.map((r) {
            return DropdownMenuItem<String>(
              value: r.id.toString(),
              child: Text(r.nome),
            );
          }).toList(),
          onChanged: (valor) {
            setState(() {
              _idResponsavelSelecionado = valor;
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
    Jogador jogador = Jogador(
      nome: _nome.text,
      cpf: _cpf.text,
      dataNascimento: _dataNascimento.text,
      idResponsavel: int.tryParse(_idResponsavelSelecionado ?? "0") ?? 0,
    );

    try {
      ControlJogador control = ControlJogador();
      int id = await control.insertDatabase(jogador);

      setState(() {
    _resultado = "Jogador ${jogador.nome} cadastrado! (id: $id)";
      });
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
