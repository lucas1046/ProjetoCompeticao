import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_tipo_evento.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaTipoEvento extends StatefulWidget {
  const TelaConsultaTipoEvento({super.key});

  @override
  State<TelaConsultaTipoEvento> createState() => _TelaConsultaTipoEventoState();
}

class _TelaConsultaTipoEventoState extends State<TelaConsultaTipoEvento> {
  String textoPesquisa = "";
  List<TipoEvento> _lista = [];
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar tipo de evento"),
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
          "Digite uma descrição para pesquisa",
          controller: _inputPesquisa,
        ),
        Buttons("Pesquisar", onPressed: _pesquisar),
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom(
            textoPesquisa.isEmpty
                ? "Toque em pesquisar para listar os tipos de evento."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map((t) => CartaoConsulta(
                t.descricao,
                ["Id: ${t.id}"],
                icone: Icons.flag,
              )),
      ],
    );
  }

  Future _pesquisar() async {
    ControlTipoEvento control = ControlTipoEvento();
    List<TipoEvento> lista = await control.queryFind(_inputPesquisa.text);

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhum tipo de evento encontrado." : "";
    });
  }
}
