import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_categoria.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarCategoria extends StatefulWidget {
  const TelaAdicionarCategoria({super.key});

  @override
  State<TelaAdicionarCategoria> createState() =>
      _TelaAdicionarCategoriaState();
}

class _TelaAdicionarCategoriaState extends State<TelaAdicionarCategoria> {
  final _nome = TextEditingController();
  final _idadeMin = TextEditingController();
  final _idadeMax = TextEditingController();
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar categoria"),
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
                "Idade mínima",
                "Informe a idade",
                controller: _idadeMin,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InputTextos(
                "Idade máxima",
                "Informe a idade",
                controller: _idadeMax,
              ),
            ),
          ],
        ),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    Categoria categoria = Categoria(
      nome: _nome.text,
      idadeMin: int.tryParse(_idadeMin.text) ?? 0,
      idadeMax: int.tryParse(_idadeMax.text) ?? 0,
    );

    ControlCategoria control = ControlCategoria();
    int id = await control.insertDatabase(categoria);

    setState(() {
      _resultado = "Categoria ${categoria.nome} cadastrada! (id: $id)";
    });
  }
}
