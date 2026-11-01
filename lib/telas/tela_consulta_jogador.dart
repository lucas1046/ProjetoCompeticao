import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaJogador extends StatefulWidget {
  const TelaConsultaJogador({super.key});

  @override
  State<TelaConsultaJogador> createState() => _TelaConsultaJogadorState();
}

class _TelaConsultaJogadorState extends State<TelaConsultaJogador> {
  List<Map<String, dynamic>> _lista = [];
  final _inputPesquisa = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pesquisar();
    _inputPesquisa.addListener(_pesquisar);
  }

  @override
  void dispose() {
    _inputPesquisa.removeListener(_pesquisar);
    _inputPesquisa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar jogador"),
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
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos("", "Digite um nome para pesquisa", controller: _inputPesquisa),
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom("Nenhum resultado", 18, Colors.red)
        else
          ..._lista.map((j) => CartaoConsulta(
                j['nome'],
                [
                  "CPF: ${j['cpf']}",
                  "Nascimento: ${j['dataNascimento']}",
                  "Responsável: ${j['nomeResponsavel'] ?? '-'}",
                ],
                icone: Icons.person,
              )),
      ],
    );
  }

  Future _pesquisar() async {
    try {
    ControlJogador control = ControlJogador();
    List<Map<String, dynamic>> lista =
        await control.queryFindDetalhado(_inputPesquisa.text);

    setState(() {
      _lista = lista;
    });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
