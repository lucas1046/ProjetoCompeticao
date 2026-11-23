import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_tecnico.dart';
import 'package:projeto_final/model/tecnico.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarTecnico extends StatefulWidget {
  final Tecnico? tecnico;
  const TelaAdicionarTecnico({super.key, this.tecnico});

  @override
  State<TelaAdicionarTecnico> createState() => _TelaAdicionarTecnicoState();
}

class _TelaAdicionarTecnicoState extends State<TelaAdicionarTecnico> {
  final _nome = TextEditingController();
  final _telefone = TextEditingController();
  final _email = TextEditingController();
  String _resultado = "";
  int? _idEdicao;

  @override
  void initState() {
    super.initState();
    if (widget.tecnico != null) {
      _idEdicao = widget.tecnico!.id;
      _nome.text = widget.tecnico!.nome;
      _telefone.text = widget.tecnico!.telefone;
      _email.text = widget.tecnico!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar técnico"),
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
      if (_idEdicao != null) {
        Tecnico t = Tecnico(id: _idEdicao, nome: _nome.text, telefone: _telefone.text, email: _email.text);
        await control.updateDatabase(t);
        setState(() => _resultado = "Técnico ${t.nome} atualizado!");
      } else {
        int id = await control.insertDatabase(tecnico);
        setState(() => _resultado = "Técnico ${tecnico.nome} cadastrado! (id: $id)");

        if (mounted) {

          await showDialog<void>(

            context: context,

            builder: (ctx) => AlertDialog(

              title: Text("Sucesso"),

              content: Text("Técnico ${tecnico.nome} cadastrado! (id: $id)"),

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
