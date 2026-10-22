import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_competicao.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarCompeticao extends StatefulWidget {
  const TelaAdicionarCompeticao({super.key});

  @override
  State<TelaAdicionarCompeticao> createState() =>
      _TelaAdicionarCompeticaoState();
}

class _TelaAdicionarCompeticaoState extends State<TelaAdicionarCompeticao> {
  final _nome = TextEditingController();
  final _cidade = TextEditingController();
  final _dataInicio = TextEditingController();
  final _dataFim = TextEditingController();
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar competição"),
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
        InputTextos("Digite a cidade", "Informe a cidade", controller: _cidade),
        InputTextos(
          "Data de início",
          "Informe a data de início",
          controller: _dataInicio,
        ),
        InputTextos(
          "Data de término",
          "Informe a data de término",
          controller: _dataFim,
        ),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    Competicao competicao = Competicao(
      nome: _nome.text,
      cidade: _cidade.text,
      dataInicio: _dataInicio.text,
      dataFim: _dataFim.text,
    );

    ControlCompeticao control = ControlCompeticao();
    int id = await control.insertDatabase(competicao);

    setState(() {
      _resultado = "Competição ${competicao.nome} cadastrada! (id: $id)";
    });
  }
}
