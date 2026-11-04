import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_escola.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/control/control_responsavel.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/control/control_foto.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/model/foto_figurinha.dart';
import 'package:projeto_final/model/posicao.dart';
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
  final _camisa = TextEditingController();
  String? _idResponsavelSelecionado;
  String? _idFotoSelecionada;
  String? _idEscolaSelecionada;
  List<Responsavel> _responsaveis = [];
  List<FotoFigurinha> _fotos = [];
  List<Escola> _escolas = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarResponsaveis();
    _carregarFotos();
    _carregarEscolas();
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

  Future<void> _carregarEscolas() async {
    final lista = await ControlEscola().queryFind();
    setState(() {
      _escolas = lista;
      if (lista.isNotEmpty) _idEscolaSelecionada = lista[0].id.toString();
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
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
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
            ),
            SizedBox(width: 8),
            IconButton(
              tooltip: "Novo responsável",
              icon: Icon(Icons.add_circle, color: Colors.green),
              onPressed: _novoResponsavel,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
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
            ),
            SizedBox(width: 8),
            IconButton(
              tooltip: "Nova foto",
              icon: Icon(Icons.add_circle, color: Colors.green),
              onPressed: _novaFoto,
            ),
          ],
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _idEscolaSelecionada,
          decoration: InputDecoration(labelText: "Escola (origem)", border: OutlineInputBorder()),
          items: _escolas.map((e) => DropdownMenuItem<String>(value: e.id.toString(), child: Text(e.nome))).toList(),
          onChanged: (v) => setState(() => _idEscolaSelecionada = v),
        ),
        SizedBox(height: 16),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _novoResponsavel() async {
    final nomeCtrl = TextEditingController();
    final cpfCtrl = TextEditingController();
    final telCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final parentCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Novo responsável"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomeCtrl, decoration: InputDecoration(labelText: "Nome")),
              SizedBox(height: 8),
              TextField(controller: cpfCtrl, decoration: InputDecoration(labelText: "CPF")),
              SizedBox(height: 8),
              TextField(controller: telCtrl, decoration: InputDecoration(labelText: "Telefone")),
              SizedBox(height: 8),
              TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Email")),
              SizedBox(height: 8),
              TextField(controller: parentCtrl, decoration: InputDecoration(labelText: "Parentesco")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Salvar")),
        ],
      ),
    );

    if (ok != true) return;

    try {
      final r = Responsavel(
        nome: nomeCtrl.text,
        cpf: cpfCtrl.text,
        telefone: telCtrl.text,
        email: emailCtrl.text,
        parentesco: parentCtrl.text,
      );
      await ControlResponsavel().insertDatabase(r);
      await _carregarResponsaveis();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Responsável criado.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _novaFoto() async {
    final pathCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Nova foto"),
        content: TextField(controller: pathCtrl, decoration: InputDecoration(labelText: "Caminho do arquivo")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Salvar")),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final f = FotoFigurinha(caminhoArquivo: pathCtrl.text, dataUpload: DateTime.now().toIso8601String().substring(0, 10));
      final id = await ControlFoto().insertDatabase(f);
      await _carregarFotos();
      setState(() => _idFotoSelecionada = id.toString());
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Foto criada.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  Future<void> _registrar() async {
    Jogador jogador = Jogador(
      nome: _nome.text,
      cpf: _cpf.text,
      dataNascimento: _dataNascimento.text,
      idResponsavel: int.tryParse(_idResponsavelSelecionado ?? "0") ?? 0,
      idFoto: int.tryParse(_idFotoSelecionada ?? ""),
      idEscola: int.tryParse(_idEscolaSelecionada ?? ""),
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
