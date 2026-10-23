import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_foto.dart';
import 'package:projeto_final/model/foto_figurinha.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarFoto extends StatefulWidget {
  const TelaAdicionarFoto({super.key});

  @override
  State<TelaAdicionarFoto> createState() => _TelaAdicionarFotoState();
}

class _TelaAdicionarFotoState extends State<TelaAdicionarFoto> {
  final _caminhoArquivo = TextEditingController();
  final _dataUpload = TextEditingController();
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar foto"),
        backgroundColor: Colors.green,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos(
          "Caminho do arquivo",
          "Informe o caminho",
          controller: _caminhoArquivo,
        ),
        InputTextos("Data do upload", "AAAA-MM-DD", controller: _dataUpload),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    FotoFigurinha foto = FotoFigurinha(
      caminhoArquivo: _caminhoArquivo.text,
      dataUpload: _dataUpload.text,
    );

    try {
      ControlFoto control = ControlFoto();
      int id = await control.insertDatabase(foto);

      setState(() {
    _resultado = "Foto cadastrada! (id: $id)";
      });
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
