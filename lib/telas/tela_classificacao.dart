import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_competicao.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaClassificacao extends StatefulWidget {
  const TelaClassificacao({super.key});

  @override
  State<TelaClassificacao> createState() => _TelaClassificacaoState();
}

class _TelaClassificacaoState extends State<TelaClassificacao> {
  List<Competicao> _competicoes = [];
  int? _idCompeticao;
  String _resultado = "";
  bool _carregando = false;
  List<Map<String, dynamic>> _classificacao = [];

  @override
  void initState() {
    super.initState();
    _carregarCompeticoes();
  }

  Future<void> _carregarCompeticoes() async {
    List<Competicao> lista = await ControlCompeticao().queryFind();
    setState(() {
      _competicoes = lista;
      if (lista.isNotEmpty) _idCompeticao = lista.first.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatório da competição"),
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
      body: _body(),
    );
  }

  ListView _body() {
    return ListView(
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
              value: c.id,
              child: Text(c.nome),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idCompeticao = v),
        ),
        SizedBox(height: 16),
        Buttons("Gerar", onPressed: _carregando ? null : () {
          _gerar();
        }),
        SizedBox(height: 16),
        if (_carregando) Center(child: CircularProgressIndicator()),
        TextosCustom(_resultado, 16, Colors.black),
      ],
    );
  }

  Future<void> _gerar() async {
    setState(() {
      _carregando = true;
      _resultado = "";
    });

    ControlRelatorio control = ControlRelatorio();
    List<Map<String, dynamic>> lista =
        await control.classificacaoGeral(idCompeticao: _idCompeticao);

    String texto = "CATEGORIA | RANKING | TIME | J | V | E | D | GP | GC | SG | PONTOS\n";
    texto += "------------------------------------------------------------\n";

    int posicao = 1;
    for (var item in lista) {
      texto += "${item['categoria'] ?? ''} | ${posicao} | ${item['nomeTime']} | ${item['jogos']} | ${item['vitorias']} | ${item['empates']} | ${item['derrotas']} | ${item['golsPro']} | ${item['golsContra']} | ${(item['golsPro'] ?? 0) - (item['golsContra'] ?? 0)} | ${item['pontos']}\n";
      posicao++;
    }

    setState(() {
      _classificacao = lista;
      _resultado = texto;
      _carregando = false;
    });
  }
}