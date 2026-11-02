import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaRelatorioChave extends StatefulWidget {
  const TelaRelatorioChave({super.key});

  @override
  State<TelaRelatorioChave> createState() => _TelaRelatorioChaveState();
}

class _TelaRelatorioChaveState extends State<TelaRelatorioChave> {
  List<Map<String, dynamic>> _competicoes = [];
  int? _idCompeticao;
  Map<String, dynamic> _dados = {};
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarCompeticoes();
  }

  Future<void> _carregarCompeticoes() async {
    final lista = await ControlRelatorio().listarCompeticoes();
    setState(() {
      _competicoes = lista;
      if (lista.isNotEmpty) _idCompeticao = lista[0]['id'] as int;
    });
  }

  Future<void> _gerar() async {
    if (_idCompeticao == null) return;
    setState(() => _carregando = true);
    final d = await ControlRelatorio().chaveCompeticao(_idCompeticao!);
    setState(() {
      _dados = d;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chave da competição"),
        backgroundColor: Colors.purple,
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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            value: _idCompeticao,
            decoration: InputDecoration(
              labelText: "Competição",
              border: OutlineInputBorder(),
            ),
            items: _competicoes.map((c) {
              return DropdownMenuItem<int>(
                value: c['id'] as int,
                child: Text(c['nome'] as String),
              );
            }).toList(),
            onChanged: (v) => setState(() => _idCompeticao = v),
          ),
          SizedBox(height: 12),
          Buttons("Gerar chave", onPressed: _carregando ? null : _gerar),
          SizedBox(height: 16),
          if (_carregando) Center(child: CircularProgressIndicator()),
          if (_dados.isNotEmpty) _renderChave(),
        ],
      ),
    );
  }

  Widget _renderChave() {
    final comp = _dados['competicao'] as Map<String, dynamic>;
    final times = (_dados['times'] as List).cast<Map<String, dynamic>>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextosCustom("${comp['nome']} — ${comp['cidade']}", 18, Colors.black),
        TextosCustom(
          "${comp['data_inicio']} a ${comp['data_fim']}",
          14,
          Colors.grey,
        ),
        SizedBox(height: 12),
        if (times.isEmpty)
          TextosCustom("Nenhum time participa desta competição.", 16, Colors.grey),
        ...times.map((t) {
          final jogs = (t['jogadores'] as List).cast<Map<String, dynamic>>();
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${t['nomeTime']}  (${t['nomeEscola']} - ${t['cidadeEscola']})",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (jogs.isEmpty)
                    Text("Sem jogadores inscritos", style: TextStyle(color: Colors.grey)),
                  ...jogs.map((j) => Text(
                        "• ${j['nome']}  (camisa ${j['camisa'] ?? '-'})",
                      )),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
