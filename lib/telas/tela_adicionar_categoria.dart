import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_categoria.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarCategoria extends StatefulWidget {
  final Categoria? categoria;
  const TelaAdicionarCategoria({super.key, this.categoria});

  @override
  State<TelaAdicionarCategoria> createState() =>
      _TelaAdicionarCategoriaState();
}

class _TelaAdicionarCategoriaState extends State<TelaAdicionarCategoria> {
  final _nome = TextEditingController();
  final _idadeMin = TextEditingController();
  final _idadeMax = TextEditingController();
  String _resultado = "";
  int? _idEdicao;

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      _idEdicao = widget.categoria!.id;
      _nome.text = widget.categoria!.nome;
      _idadeMin.text = widget.categoria!.idadeMin.toString();
      _idadeMax.text = widget.categoria!.idadeMax.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar categoria"),
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

    try {
      ControlCategoria control = ControlCategoria();
      if (_idEdicao != null) {
        Categoria c = Categoria(id: _idEdicao, nome: _nome.text, idadeMin: int.tryParse(_idadeMin.text) ?? 0, idadeMax: int.tryParse(_idadeMax.text) ?? 0);
        await control.updateDatabase(c);
        setState(() => _resultado = "Categoria ${c.nome} atualizada!");
      } else {
        int id = await control.insertDatabase(categoria);
        setState(() => _resultado = "Categoria ${categoria.nome} cadastrada! (id: $id)");

        if (mounted) {

          await showDialog<void>(

            context: context,

            builder: (ctx) => AlertDialog(

              title: Text("Sucesso"),

              content: Text("Categoria ${categoria.nome} cadastrada! (id: $id)"),

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
