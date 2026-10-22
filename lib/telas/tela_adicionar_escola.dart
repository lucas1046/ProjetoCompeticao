import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_escola.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarEscola extends StatefulWidget {
  const TelaAdicionarEscola({super.key});

  @override
  State<TelaAdicionarEscola> createState() => _TelaAdicionarEscolaState();
}

class _TelaAdicionarEscolaState extends State<TelaAdicionarEscola> {
  final _nome = TextEditingController();
  final _cidade = TextEditingController();
  final _estado = TextEditingController();
  final _telefone = TextEditingController();
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar escola"),
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
        Row(
          children: [
            Expanded(
              child: InputTextos(
                "Cidade",
                "Informe a cidade",
                controller: _cidade,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InputTextos(
                "Estado",
                "Ex: SP",
                controller: _estado,
              ),
            ),
          ],
        ),
        InputTextos("Telefone", "Informe o telefone", controller: _telefone),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    Escola escola = Escola(
      nome: _nome.text,
      cidade: _cidade.text,
      estado: _estado.text,
      telefone: _telefone.text,
    );

    ControlEscola control = ControlEscola();
    int id = await control.insertDatabase(escola);

    setState(() {
      _resultado = "Escola ${escola.nome} cadastrada! (id: $id)";
    });
  }
}
