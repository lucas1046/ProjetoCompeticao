import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_documento.dart';
import 'package:projeto_final/model/documento.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaDocumento extends StatefulWidget {
  const TelaConsultaDocumento({super.key});

  @override
  State<TelaConsultaDocumento> createState() => _TelaConsultaDocumentoState();
}

class _TelaConsultaDocumentoState extends State<TelaConsultaDocumento> {
  String textoPesquisa = "";
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar documento"),
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
          "Digite um tipo de documento",
          controller: _inputPesquisa,
        ),
        Buttons("Pesquisar", onPressed: _pesquisar),
        TextosCustom(textoPesquisa, 18, Colors.red),
      ],
    );
  }

  Future _pesquisar() async {
    ControlDocumento control = ControlDocumento();
    List<Documento> lista = await control.queryFind(_inputPesquisa.text);

    String texto = "";
    for (Documento d in lista) {
      texto += "${d.id} - ${d.tipoDocumento} - jogador: ${d.idJogador}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
