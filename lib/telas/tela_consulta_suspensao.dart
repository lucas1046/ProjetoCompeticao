import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_suspensao.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaSuspensao extends StatefulWidget {
  const TelaConsultaSuspensao({super.key});

  @override
  State<TelaConsultaSuspensao> createState() => _TelaConsultaSuspensaoState();
}

class _TelaConsultaSuspensaoState extends State<TelaConsultaSuspensao> {
  String textoPesquisa = "";
  List<Map<String, dynamic>> _lista = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar suspensões"),
        backgroundColor: Colors.orange,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Buttons("Pesquisar", onPressed: _pesquisar),
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom(
            textoPesquisa.isEmpty
                ? "Toque em pesquisar para listar as suspensões."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map(_cartao),
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
    ControlSuspensao control = ControlSuspensao();
    List<Map<String, dynamic>> lista = await control.queryFindDetalhado();

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhuma suspensão encontrada." : "";
    });
  }
}
