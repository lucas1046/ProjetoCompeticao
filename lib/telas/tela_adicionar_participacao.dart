import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_escola.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/control/control_participacao.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/model/participacao_jogador_time.dart';
import 'package:projeto_final/control/control_responsavel.dart';
import 'package:projeto_final/model/responsavel.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarParticipacao extends StatefulWidget {
  const TelaAdicionarParticipacao({super.key});

  @override
  State<TelaAdicionarParticipacao> createState() =>
      _TelaAdicionarParticipacaoState();
}

class _TelaAdicionarParticipacaoState extends State<TelaAdicionarParticipacao> {
  final _valorInscricao = TextEditingController();
  String? _idJogador;
  String? _idEscola;
  List<Jogador> _jogadores = [];
  List<Escola> _escolas = [];
  List<Responsavel> _responsaveis = [];
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    List<Jogador> jogadores = await ControlJogador().queryFind();
    List<Escola> escolas = await ControlEscola().queryFind();
    List<Responsavel> resps = await ControlResponsavel().queryFind();

    setState(() {
      _jogadores = jogadores;
      _escolas = escolas;
      _responsaveis = resps;
      if (jogadores.isNotEmpty) _idJogador = jogadores[0].id.toString();
      if (escolas.isNotEmpty) _idEscola = escolas[0].id.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inscrever jogador"),
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
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _idJogador,
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
                onChanged: (v) => setState(() => _idJogador = v),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              tooltip: "Novo jogador",
              icon: Icon(Icons.add_circle, color: Colors.green),
              onPressed: _novoJogador,
            ),
          ],
        ),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _idEscola,
          decoration: InputDecoration(
            labelText: "Escola de origem",
            border: OutlineInputBorder(),
          ),
          items: _escolas.map((e) {
            return DropdownMenuItem<String>(
              value: e.id.toString(),
              child: Text(e.nome),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idEscola = v),
        ),
        SizedBox(height: 12),
        InputTextos("Valor da inscrição", "0.00", controller: _valorInscricao),
        SizedBox(height: 16),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _novoJogador() async {
    final nomeCtrl = TextEditingController();
    final cpfCtrl = TextEditingController();
    final dataCtrl = TextEditingController();
    int? idResp = _responsaveis.isNotEmpty ? _responsaveis[0].id : null;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text("Novo jogador"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nomeCtrl, decoration: InputDecoration(labelText: "Nome")),
                SizedBox(height: 8),
                TextField(controller: cpfCtrl, decoration: InputDecoration(labelText: "CPF")),
                SizedBox(height: 8),
                TextField(controller: dataCtrl, decoration: InputDecoration(labelText: "Data nasc. (AAAA-MM-DD)")),
                SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: idResp,
                  decoration: InputDecoration(labelText: "Responsável"),
                  items: _responsaveis.map((r) {
                    return DropdownMenuItem<int>(value: r.id, child: Text(r.nome));
                  }).toList(),
                  onChanged: (v) => setD(() => idResp = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar")),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Salvar")),
          ],
        ),
      ),
    );

    if (ok != true) return;

    try {
      final j = Jogador(
        nome: nomeCtrl.text,
        cpf: cpfCtrl.text,
        dataNascimento: dataCtrl.text,
        idResponsavel: idResp ?? 0,
      );
      await ControlJogador().insertDatabase(j);
      await _carregarListas();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Jogador criado.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _registrar() async {
    ParticipacaoJogadorTime participacao = ParticipacaoJogadorTime(
      idJogador: int.tryParse(_idJogador ?? "0") ?? 0,
      idEscola: int.tryParse(_idEscola ?? "0"),
      valorInscricao: double.tryParse(_valorInscricao.text),
    );

    try {
      ControlParticipacao control = ControlParticipacao();
      int id = await control.insertDatabase(participacao);

      setState(() {
        _resultado = "Inscrição cadastrada! (id: $id)";
      });
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}