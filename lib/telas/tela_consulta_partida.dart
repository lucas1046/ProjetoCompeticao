import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';

import 'package:projeto_final/control/control_partida.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaPartida extends StatefulWidget {
  const TelaConsultaPartida({super.key});

  @override
  State<TelaConsultaPartida> createState() => _TelaConsultaPartidaState();
}

class _TelaConsultaPartidaState extends State<TelaConsultaPartida> {
  @override
  void initState() {
    super.initState();
    _pesquisar();
    _filtro.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _filtro.dispose();
    super.dispose();
  }
  List<Map<String, dynamic>> _lista = [];
  final _filtro = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar partidas"),
        backgroundColor: Colors.orange,
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
    String f = _filtro.text.trim().toLowerCase();
    List<Map<String, dynamic>> filtrados = f.isEmpty
        ? _lista
        : _lista.where((item) => item.values.any((v) => v.toString().toLowerCase().contains(f))).toList();

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos("", "Digite para filtrar", controller: _filtro),
        SizedBox(height: 16),
        if (filtrados.isEmpty)
          TextosCustom("Nenhum resultado", 18, Colors.red)
        else
          ...filtrados.map(_cartao),
      ],
    );
  }

  Widget _cartao(Map<String, dynamic> p) {
    int golsCasa = (p['golsCasa'] as num?)?.toInt() ?? 0;
    int golsVisitante = (p['golsVisitante'] as num?)?.toInt() ?? 0;
    bool wo = p['wo'] == 1;

    String resultado = "$golsCasa x $golsVisitante";
    if (wo) {
      resultado = "WO";
    }

    return CartaoConsulta(
      "${p['nomeTimeCasa']} x ${p['nomeTimeVisitante']}",
      [
        "${p['nomeCompeticao']} - Rodada ${p['numeroRodada']}",
      ],
      selo: resultado,
      corSelo: Colors.blue,
      icone: Icons.sports_score,
    );
  }

  Future _pesquisar() async {
    try {
    ControlPartida control = ControlPartida();
    List<Map<String, dynamic>> lista = await control.queryFindDetalhado();

    setState(() {
      _lista = lista;
    });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
