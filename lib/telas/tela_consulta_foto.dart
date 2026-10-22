import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_foto.dart';
import 'package:projeto_final/model/foto_figurinha.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaFoto extends StatefulWidget {
  const TelaConsultaFoto({super.key});

  @override
  State<TelaConsultaFoto> createState() => _TelaConsultaFotoState();
}

class _TelaConsultaFotoState extends State<TelaConsultaFoto> {
  String textoPesquisa = "";
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar foto"),
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
          "Digite um caminho para pesquisa",
          controller: _inputPesquisa,
        ),
        Buttons("Pesquisar", onPressed: _pesquisar),
        TextosCustom(textoPesquisa, 18, Colors.red),
      ],
    );
  }

  Future _pesquisar() async {
    ControlFoto control = ControlFoto();
    List<FotoFigurinha> lista = await control.queryFind(_inputPesquisa.text);

    String texto = "";
    for (FotoFigurinha f in lista) {
      texto += "${f.id} - ${f.caminhoArquivo} - ${f.dataUpload}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
