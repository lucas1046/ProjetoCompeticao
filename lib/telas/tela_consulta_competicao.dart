import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_competicao.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaCompeticao extends StatefulWidget {
  const TelaConsultaCompeticao({super.key});

  @override
  State<TelaConsultaCompeticao> createState() => _TelaConsultaCompeticaoState();
}

class _TelaConsultaCompeticaoState extends State<TelaConsultaCompeticao> {
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
  List<Competicao> _lista = [];
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar competição"),
        backgroundColor: Colors.orange,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos("", "Digite para filtrar", controller: _inputPesquisa),
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom("Nenhum resultado", 18, Colors.red)
        else
          ..._lista.map((c) => CartaoConsulta(
                c.nome,
                [
                  "Cidade: ${c.cidade}",
                  "De ${c.dataInicio} até ${c.dataFim}",
                ],
                icone: Icons.emoji_events,
              )),
      ],
    );
  }

  Future _pesquisar() async {
    try {
    ControlCompeticao control = ControlCompeticao();
    List<Competicao> lista = await control.queryFind(_inputPesquisa.text);

    setState(() {
      _lista = lista;
    });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
