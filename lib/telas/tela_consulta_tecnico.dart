import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_tecnico.dart';
import 'package:projeto_final/model/tecnico.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaTecnico extends StatefulWidget {
  const TelaConsultaTecnico({super.key});

  @override
  State<TelaConsultaTecnico> createState() => _TelaConsultaTecnicoState();
}

class _TelaConsultaTecnicoState extends State<TelaConsultaTecnico> {
  String textoPesquisa = "";
  List<Tecnico> _lista = [];
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar técnico"),
        backgroundColor: Colors.orange,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos(
          "",
          "Digite um nome para pesquisa",
          controller: _inputPesquisa,
        ),
        Buttons("Pesquisar", onPressed: _pesquisar),
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom(
            textoPesquisa.isEmpty
                ? "Toque em pesquisar para listar os técnicos."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map((t) => CartaoConsulta(
                t.nome,
                [
                  if (t.telefone.trim().isNotEmpty) "Telefone: ${t.telefone}",
                  if (t.email.trim().isNotEmpty) "E-mail: ${t.email}",
                ],
                icone: Icons.escalator_warning,
              )),
      ],
    );
  }

  Future _pesquisar() async {
    ControlTecnico control = ControlTecnico();
    List<Tecnico> lista = await control.queryFind(_inputPesquisa.text);

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhum técnico encontrado." : "";
    });
  }
}
