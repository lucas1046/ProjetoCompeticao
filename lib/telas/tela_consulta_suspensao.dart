import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_suspensao.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaSuspensao extends StatefulWidget {
  const TelaConsultaSuspensao({super.key});

  @override
  State<TelaConsultaSuspensao> createState() => _TelaConsultaSuspensaoState();
}

class _TelaConsultaSuspensaoState extends State<TelaConsultaSuspensao> {
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
        title: Text("Consultar suspensões"),
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

  Widget _cartao(Map<String, dynamic> s) {
    bool cumprida = s['cumprida'] == 1;

    return CartaoConsulta(
      s['motivo'] ?? "-",
      [
        "Jogador: ${s['nomeJogador']}",
        "${s['tipoEvento']} - Minuto ${s['minuto']} - ${s['qtdJogos']} jogo(s)",
      ],
      selo: cumprida ? "CUMPRIDA" : "EM ABERTO",
      corSelo: cumprida ? Colors.green : Colors.red,
      icone: Icons.block,
    );
  }

  Future _pesquisar() async {
    try {
    ControlSuspensao control = ControlSuspensao();
    List<Map<String, dynamic>> lista = await control.queryFindDetalhado();

    setState(() {
      _lista = lista;
    });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
