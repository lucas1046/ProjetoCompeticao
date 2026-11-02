import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_categoria.dart';
import 'package:projeto_final/control/control_escola.dart';
import 'package:projeto_final/control/control_modalidade.dart';
import 'package:projeto_final/control/control_time.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/model/modalidade.dart';
import 'package:projeto_final/model/time.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarTime extends StatefulWidget {
  const TelaAdicionarTime({super.key});

  @override
  State<TelaAdicionarTime> createState() => _TelaAdicionarTimeState();
}

class _TelaAdicionarTimeState extends State<TelaAdicionarTime> {
  final _nomeTime = TextEditingController();
  String? _idModalidade;
  String? _idEscola;
  String? _idCategoria;
  List<Modalidade> _modalidades = [];
  List<Escola> _escolas = [];
  List<Categoria> _categorias = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    ControlModalidade controlModalidade = ControlModalidade();
    ControlEscola controlEscola = ControlEscola();
    ControlCategoria controlCategoria = ControlCategoria();

    List<Modalidade> modalidades = await controlModalidade.queryFind();
    List<Escola> escolas = await controlEscola.queryFind();
    List<Categoria> categorias = await controlCategoria.queryFind();

    setState(() {
      _modalidades = modalidades;
      _escolas = escolas;
      _categorias = categorias;
      if (modalidades.isNotEmpty) _idModalidade = modalidades[0].id.toString();
      if (escolas.isNotEmpty) _idEscola = escolas[0].id.toString();
      if (categorias.isNotEmpty) _idCategoria = categorias[0].id.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar time"),
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
        InputTextos(
          "Digite o nome do time",
          "Informe o nome",
          controller: _nomeTime,
        ),
        _dropdown("Modalidade", _idModalidade, _modalidades
            .map((m) => _Item(m.id.toString(), m.nome))
            .toList(), (v) {
          setState(() {
            _idModalidade = v;
          });
        }),
        SizedBox(height: 4),
        TextButton.icon(
          onPressed: _novaModalidade,
          icon: Icon(Icons.add, color: Colors.green),
          label: Text("Nova modalidade", style: TextStyle(color: Colors.green)),
        ),
        SizedBox(height: 12),
        _dropdown("Escola", _idEscola,
            _escolas.map((e) => _Item(e.id.toString(), e.nome)).toList(), (v) {
          setState(() {
            _idEscola = v;
          });
        }),
        SizedBox(height: 4),
        TextButton.icon(
          onPressed: _novaEscola,
          icon: Icon(Icons.add, color: Colors.green),
          label: Text("Nova escola", style: TextStyle(color: Colors.green)),
        ),
        SizedBox(height: 12),
        _dropdown("Categoria", _idCategoria, _categorias
            .map((c) => _Item(c.id.toString(), c.nome))
            .toList(), (v) {
          setState(() {
            _idCategoria = v;
          });
        }),
        SizedBox(height: 4),
        TextButton.icon(
          onPressed: _novaCategoria,
          icon: Icon(Icons.add, color: Colors.green),
          label: Text("Nova categoria", style: TextStyle(color: Colors.green)),
        ),
        SizedBox(height: 16),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Widget _dropdown(
    String rotulo,
    String? valor,
    List<_Item> itens,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: valor,
      decoration: InputDecoration(
        labelText: rotulo,
        border: OutlineInputBorder(),
      ),
      items: itens.map((i) {
        return DropdownMenuItem<String>(value: i.id, child: Text(i.nome));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _novaEscola() async {
    final nomeCtrl = TextEditingController();
    final cidadeCtrl = TextEditingController();
    final estadoCtrl = TextEditingController();
    final telCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Nova escola"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomeCtrl, decoration: InputDecoration(labelText: "Nome")),
            SizedBox(height: 8),
            TextField(controller: cidadeCtrl, decoration: InputDecoration(labelText: "Cidade")),
            SizedBox(height: 8),
            TextField(controller: estadoCtrl, decoration: InputDecoration(labelText: "Estado")),
            SizedBox(height: 8),
            TextField(controller: telCtrl, decoration: InputDecoration(labelText: "Telefone")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Salvar")),
        ],
      ),
    );

    if (ok != true) return;

    try {
      final escola = Escola(
        nome: nomeCtrl.text,
        cidade: cidadeCtrl.text,
        estado: estadoCtrl.text,
        telefone: telCtrl.text,
      );
      await ControlEscola().insertDatabase(escola);
      await _carregarListas();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Escola criada.")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _novaModalidade() async {
    final nomeCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Nova modalidade"),
        content: TextField(controller: nomeCtrl, decoration: InputDecoration(labelText: "Nome")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Salvar")),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final m = Modalidade(nome: nomeCtrl.text);
      await ControlModalidade().insertDatabase(m);
      await _carregarListas();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Modalidade criada.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _novaCategoria() async {
    final nomeCtrl = TextEditingController();
    final minCtrl = TextEditingController();
    final maxCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Nova categoria"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomeCtrl, decoration: InputDecoration(labelText: "Nome")),
            SizedBox(height: 8),
            TextField(controller: minCtrl, decoration: InputDecoration(labelText: "Idade mín."), keyboardType: TextInputType.number),
            SizedBox(height: 8),
            TextField(controller: maxCtrl, decoration: InputDecoration(labelText: "Idade máx."), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Salvar")),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final c = Categoria(
        nome: nomeCtrl.text,
        idadeMin: int.tryParse(minCtrl.text) ?? 0,
        idadeMax: int.tryParse(maxCtrl.text) ?? 0,
      );
      await ControlCategoria().insertDatabase(c);
      await _carregarListas();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Categoria criada.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _registrar() async {
    Time time = Time(
      nomeTime: _nomeTime.text,
      idModalidade: int.tryParse(_idModalidade ?? "0") ?? 0,
      idEscola: int.tryParse(_idEscola ?? "0") ?? 0,
      idCategoria: int.tryParse(_idCategoria ?? "0") ?? 0,
    );

    try {
      ControlTime control = ControlTime();
      int id = await control.insertDatabase(time);

      setState(() {
    _resultado = "Time ${time.nomeTime} cadastrado! (id: $id)";
      });
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}

class _Item {
  final String id;
  final String nome;

  _Item(this.id, this.nome);
}
