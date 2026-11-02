import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/control/control_responsavel.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/control/control_foto.dart';
import 'package:projeto_final/model/foto_figurinha.dart';
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
  String? _idFotoSelecionada;
  List<Responsavel> _responsaveis = [];
  List<FotoFigurinha> _fotos = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarResponsaveis();
    _carregarFotos();
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

  Future<void> _carregarFotos() async {
    final lista = await ControlFoto().queryFind();
    setState(() {
      _fotos = lista;
      if (lista.isNotEmpty) _idFotoSelecionada = lista[0].id.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar jogador"),
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
        DropdownButtonFormField<String>(
          value: _idFotoSelecionada,
          decoration: InputDecoration(
            labelText: "Foto (opcional)",
            border: OutlineInputBorder(),
          ),
          items: _fotos.map((f) {
            return DropdownMenuItem<String>(
              value: f.id.toString(),
              child: Text(f.caminhoArquivo.split('/').last),
            );
          }).toList(),
          onChanged: (valor) {
            setState(() {
              _idFotoSelecionada = valor;
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
      idFoto: int.tryParse(_idFotoSelecionada ?? ""),
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
