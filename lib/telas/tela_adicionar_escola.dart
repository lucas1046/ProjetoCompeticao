import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_escola.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarEscola extends StatefulWidget {
  final Escola? escola;
  const TelaAdicionarEscola({super.key, this.escola});

  @override
  State<TelaAdicionarEscola> createState() => _TelaAdicionarEscolaState();
}

class _TelaAdicionarEscolaState extends State<TelaAdicionarEscola> {
  final _nome = TextEditingController();
  final _cidade = TextEditingController();
  final _estado = TextEditingController();
  final _telefone = TextEditingController();
  String _resultado = "";
  int? _idEdicao;

  @override
  void initState() {
    super.initState();
    if (widget.escola != null) {
      _idEdicao = widget.escola!.id;
      _nome.text = widget.escola!.nome;
      _cidade.text = widget.escola!.cidade;
      _estado.text = widget.escola!.estado;
      _telefone.text = widget.escola!.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar escola"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => Menu()),
              (_) => false,
            ),
          ),
        ],
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

    try {
      ControlEscola control = ControlEscola();
      if (_idEdicao != null) {
        Escola e = Escola(id: _idEdicao, nome: _nome.text, cidade: _cidade.text, estado: _estado.text, telefone: _telefone.text);
        await control.updateDatabase(e);
        setState(() => _resultado = "Escola ${e.nome} atualizada!");
      } else {
        int id = await control.insertDatabase(escola);
        setState(() => _resultado = "Escola ${escola.nome} cadastrada! (id: $id)");
      }
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
