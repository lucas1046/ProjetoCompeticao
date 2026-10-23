import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_tecnico.dart';
import 'package:projeto_final/model/tecnico.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarTecnico extends StatefulWidget {
  const TelaAdicionarTecnico({super.key});

  @override
  State<TelaAdicionarTecnico> createState() => _TelaAdicionarTecnicoState();
}

class _TelaAdicionarTecnicoState extends State<TelaAdicionarTecnico> {
  final _nome = TextEditingController();
  final _telefone = TextEditingController();
  final _email = TextEditingController();
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar técnico"),
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
        InputTextos("Telefone", "Informe o telefone", controller: _telefone),
        InputTextos("E-mail", "Informe o e-mail", controller: _email),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    Tecnico tecnico = Tecnico(
      nome: _nome.text,
      telefone: _telefone.text,
      email: _email.text,
    );

    try {
      ControlTecnico control = ControlTecnico();
      int id = await control.insertDatabase(tecnico);

      setState(() {
    _resultado = "Técnico ${tecnico.nome} cadastrado! (id: $id)";
      });
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
