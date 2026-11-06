import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_competicao.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarCompeticao extends StatefulWidget {
  final Competicao? competicao;
  const TelaAdicionarCompeticao({super.key, this.competicao});

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
  int? _idEdicao;

  @override
  void initState() {
    super.initState();
    if (widget.competicao != null) {
      _idEdicao = widget.competicao!.id;
      _nome.text = widget.competicao!.nome;
      _cidade.text = widget.competicao!.cidade;
      _dataInicio.text = widget.competicao!.dataInicio;
      _dataFim.text = widget.competicao!.dataFim;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar competição"),
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

  ListView _body() {
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

    try {
      ControlCompeticao control = ControlCompeticao();
      if (_idEdicao != null) {
        Competicao c = Competicao(id: _idEdicao, nome: _nome.text, cidade: _cidade.text, dataInicio: _dataInicio.text, dataFim: _dataFim.text);
        await control.updateDatabase(c);
        setState(() => _resultado = "Competição ${c.nome} atualizada!");
      } else {
        int id = await control.insertDatabase(competicao);
        setState(() => _resultado = "Competição ${competicao.nome} cadastrada! (id: $id)");

        if (mounted) {

          await showDialog<void>(

            context: context,

            builder: (ctx) => AlertDialog(

              title: Text("Sucesso"),

              content: Text("Competição ${competicao.nome} cadastrada! (id: $id)"),

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
