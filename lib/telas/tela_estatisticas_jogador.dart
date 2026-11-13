import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';
import 'package:projeto_final/util/formatador.dart';

class TelaEstatisticasJogador extends StatefulWidget {
  const TelaEstatisticasJogador({super.key});

  @override
  State<TelaEstatisticasJogador> createState() =>
      _TelaEstatisticasJogadorState();
}

class _TelaEstatisticasJogadorState extends State<TelaEstatisticasJogador> {
  List<Jogador> _jogadores = [];
  String? _idJogador;
  String _resultado = "";
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarJogadores();
  }

  Future<void> _carregarJogadores() async {
    List<Jogador> lista = await ControlJogador().queryFind();
    setState(() {
      _jogadores = lista;
      if (lista.isNotEmpty) _idJogador = lista.first.id.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ficha do jogador"),
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
        DropdownButtonFormField<String>(
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
        SizedBox(height: 16),
        Buttons("Consultar", onPressed: _carregando ? null : () {
          _consultar();
        }),
        SizedBox(height: 16),
        if (_carregando) Center(child: CircularProgressIndicator()),
        TextosCustom(_resultado, 16, Colors.black),
      ],
    );
  }

  Future<void> _consultar() async {
    setState(() {
      _carregando = true;
      _resultado = "";
    });

    try {
      ControlRelatorio control = ControlRelatorio();
      List<Map<String, dynamic>> lista = await control.fichaJogador();
      String busca = "";
      if (_idJogador != null) {
        Jogador? j = _jogadores.firstWhere((x) => x.id.toString() == _idJogador, orElse: () => _jogadores.first);
        busca = j.nome.toLowerCase();
      }
      if (busca.isNotEmpty) {
        lista = lista
            .where((m) => (m['jogador'] ?? '')
                .toString()
                .toLowerCase()
                .contains(busca))
            .toList();
      }

      if (lista.isEmpty) {
        setState(() {
          _resultado = "Nenhum jogador encontrado.";
          _carregando = false;
        });
        return;
      }

      String texto = "";
      for (var m in lista) {
        texto += "ESCOLA: ${m['escola'] ?? ''}\n";
        texto += "JOGADOR: ${m['jogador'] ?? ''}\n";
        texto += "CATEGORIA: ${m['categoria'] ?? ''}\n";
        texto += "TOTAL DE GOLS: ${m['total_gols'] ?? 0}\n";
        texto += "VALOR TOTAL: ${m['valor_total'] ?? ''}\n";
        texto += "RESPONSÁVEL: ${m['responsavel'] ?? ''}\n";
        texto += "DATA NASCIMENTO: ${Formatador.dataBr(m['data_nascimento'] ?? '')}\n";
        texto += "-----------------------------\n";
      }

      setState(() {
        _resultado = texto;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _resultado = "Erro: $e";
        _carregando = false;
      });
    }
  }
}