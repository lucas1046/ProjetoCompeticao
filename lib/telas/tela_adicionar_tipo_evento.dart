import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_tipo_evento.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarTipoEvento extends StatefulWidget {
  final TipoEvento? tipoEvento;
  const TelaAdicionarTipoEvento({super.key, this.tipoEvento});

  @override
  State<TelaAdicionarTipoEvento> createState() =>
      _TelaAdicionarTipoEventoState();
}

class _TelaAdicionarTipoEventoState extends State<TelaAdicionarTipoEvento> {
  final _descricao = TextEditingController();
  String _resultado = "";
  int? _idEdicao;

  @override
  void initState() {
    super.initState();
    if (widget.tipoEvento != null) {
      _idEdicao = widget.tipoEvento!.id;
      _descricao.text = widget.tipoEvento!.descricao;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar tipo de evento"),
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

  ListView _body() {
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
      if (_idEdicao != null) {
        TipoEvento t = TipoEvento(id: _idEdicao, descricao: _descricao.text);
        await control.updateDatabase(t);
        setState(() => _resultado = "Tipo de evento ${t.descricao} atualizado!");
      } else {
        int id = await control.insertDatabase(tipoEvento);
        setState(() => _resultado = "Tipo de evento ${tipoEvento.descricao} cadastrado! (id: $id)");

        if (mounted) {

          await showDialog<void>(

            context: context,

            builder: (ctx) => AlertDialog(

              title: Text("Sucesso"),

              content: Text("Tipo de evento ${tipoEvento.descricao} cadastrado! (id: $id)"),

              actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text("OK"))],

            ),

          );

          if (mounted) Navigator.pop(context);

        }
      }
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
