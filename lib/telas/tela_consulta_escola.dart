import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_escola.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaEscola extends StatefulWidget {
  const TelaConsultaEscola({super.key});

  @override
  State<TelaConsultaEscola> createState() => _TelaConsultaEscolaState();
}

class _TelaConsultaEscolaState extends State<TelaConsultaEscola> {
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
  List<Escola> _lista = [];
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar escola"),
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
          ..._lista.map((e) => CartaoConsulta(
                e.nome,
                [
                  "Cidade: ${e.cidade}/${e.estado}",
                  if (e.telefone.trim().isNotEmpty) "Telefone: ${e.telefone}",
                ],
                icone: Icons.school,
              )),
      ],
    );
  }

  Future _pesquisar() async {
    try {
    ControlEscola control = ControlEscola();
    List<Escola> lista = await control.queryFind(_inputPesquisa.text);

    setState(() {
      _lista = lista;
    });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
