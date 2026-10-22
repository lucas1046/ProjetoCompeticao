import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_responsavel.dart';
import 'package:projeto_final/model/responsavel.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarResponsavel extends StatefulWidget {
  const TelaAdicionarResponsavel({super.key});

  @override
  State<TelaAdicionarResponsavel> createState() =>
      _TelaAdicionarResponsavelState();
}

class _TelaAdicionarResponsavelState extends State<TelaAdicionarResponsavel> {
  final _nome = TextEditingController();
  final _cpf = TextEditingController();
  final _telefone = TextEditingController();
  final _email = TextEditingController();
  final _parentesco = TextEditingController();
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar responsável"),
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
        InputTextos("Digite o CPF", "Informe o CPF", controller: _cpf),
        Row(
          children: [
            Expanded(
              child: InputTextos(
                "Telefone",
                "Informe o telefone",
                controller: _telefone,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InputTextos(
                "Parentesco",
                "Pai, mãe...",
                controller: _parentesco,
              ),
            ),
          ],
        ),
        InputTextos("Digite o e-mail", "Informe o e-mail", controller: _email),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    Responsavel responsavel = Responsavel(
      nome: _nome.text,
      cpf: _cpf.text,
      telefone: _telefone.text,
      email: _email.text,
      parentesco: _parentesco.text,
    );

    ControlResponsavel control = ControlResponsavel();
    int id = await control.insertDatabase(responsavel);

    setState(() {
      _resultado = "Responsável ${responsavel.nome} cadastrado! (id: $id)";
    });
  }
}
