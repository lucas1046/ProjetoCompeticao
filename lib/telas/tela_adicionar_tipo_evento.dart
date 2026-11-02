import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_tipo_evento.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarTipoEvento extends StatefulWidget {
  const TelaAdicionarTipoEvento({super.key});

  @override
  State<TelaAdicionarTipoEvento> createState() =>
      _TelaAdicionarTipoEventoState();
}

class _TelaAdicionarTipoEventoState extends State<TelaAdicionarTipoEvento> {
  final _descricao = TextEditingController();
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar tipo de evento"),
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
        InputTextos(
          "Digite a descrição",
          "Ex: Gol, Cartão amarelo, Cartão vermelho",
          controller: _descricao,
        ),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    TipoEvento tipoEvento = TipoEvento(descricao: _descricao.text);

    try {
      ControlTipoEvento control = ControlTipoEvento();
      int id = await control.insertDatabase(tipoEvento);

      setState(() {
    _resultado = "Tipo de evento ${tipoEvento.descricao} cadastrado! (id: $id)";
      });
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
