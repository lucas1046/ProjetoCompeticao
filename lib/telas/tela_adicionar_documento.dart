import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_documento.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/model/documento.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarDocumento extends StatefulWidget {
  const TelaAdicionarDocumento({super.key});

  @override
  State<TelaAdicionarDocumento> createState() => _TelaAdicionarDocumentoState();
}

class _TelaAdicionarDocumentoState extends State<TelaAdicionarDocumento> {
  final _tipoDocumento = TextEditingController();
  final _caminhoArquivo = TextEditingController();
  String? _idJogadorSelecionado;
  List<Jogador> _jogadores = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarJogadores();
  }

  Future<void> _carregarJogadores() async {
    ControlJogador control = ControlJogador();
    List<Jogador> lista = await control.queryFind();
    setState(() {
      _jogadores = lista;
      if (lista.isNotEmpty) {
        _idJogadorSelecionado = lista[0].id.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar documento"),
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
          value: _idJogadorSelecionado,
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
          onChanged: (valor) {
            setState(() {
              _idJogadorSelecionado = valor;
            });
          },
        ),
        SizedBox(height: 16),
        InputTextos(
          "Tipo do documento",
          "Ex: RG, CPF, Autorização",
          controller: _tipoDocumento,
        ),
        InputTextos(
          "Caminho do arquivo",
          "Informe o caminho",
          controller: _caminhoArquivo,
        ),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    Documento documento = Documento(
      idJogador: int.tryParse(_idJogadorSelecionado ?? "0") ?? 0,
      tipoDocumento: _tipoDocumento.text,
      caminhoArquivo: _caminhoArquivo.text,
    );

    ControlDocumento control = ControlDocumento();
    int id = await control.insertDatabase(documento);

    setState(() {
      _resultado = "Documento ${documento.tipoDocumento} cadastrado! (id: $id)";
    });
  }
}
