import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_modalidade.dart';
import 'package:projeto_final/model/modalidade.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarModalidade extends StatefulWidget {
  const TelaAdicionarModalidade({super.key});

  @override
  State<TelaAdicionarModalidade> createState() =>
      _TelaAdicionarModalidadeState();
}

class _TelaAdicionarModalidadeState extends State<TelaAdicionarModalidade> {
  final _nome = TextEditingController();
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar modalidade"),
        backgroundColor: Colors.green,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos("Digite o nome", "Informe o nome", controller: _nome),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    Modalidade modalidade = Modalidade(nome: _nome.text);

    ControlModalidade control = ControlModalidade();
    int id = await control.insertDatabase(modalidade);

    setState(() {
      _resultado = "Modalidade ${modalidade.nome} cadastrada! (id: $id)";
    });
  }
}
