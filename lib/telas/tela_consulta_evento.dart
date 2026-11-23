import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_evento.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaEvento extends StatefulWidget {
  const TelaConsultaEvento({super.key});

  @override
  State<TelaConsultaEvento> createState() => _TelaConsultaEventoState();
}

class _TelaConsultaEventoState extends State<TelaConsultaEvento> {
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
        title: Text("Consultar eventos"),
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

  Widget _cartao(Map<String, dynamic> e) {
    List<String> linhas = [
      "Jogador: ${e['nomeJogador']} - ${e['nomeTime']}",
      "Minuto: ${e['minuto']}",
    ];

    if (e['descricao'] != null && (e['descricao'] as String).isNotEmpty) {
      linhas.add(e['descricao']);
    }

    return CartaoConsulta(
      e['tipoEvento'] ?? "-",
      linhas,
      icone: Icons.timer,
    );
  }

  Future _pesquisar() async {
    try {
    ControlEvento control = ControlEvento();
    List<Map<String, dynamic>> lista = await control.queryFindDetalhado();

    setState(() {
      _lista = lista;
    });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
