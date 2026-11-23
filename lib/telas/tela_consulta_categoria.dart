import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_categoria.dart';
import 'package:projeto_final/telas/tela_adicionar_categoria.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaCategoria extends StatefulWidget {
  const TelaConsultaCategoria({super.key});

  @override
  State<TelaConsultaCategoria> createState() => _TelaConsultaCategoriaState();
}

class _TelaConsultaCategoriaState extends State<TelaConsultaCategoria> {
  @override
  void initState() {
    super.initState();
    _pesquisar();
    _inputPesquisa.addListener(_pesquisar);
  }

  @override
  void dispose() {
    _inputPesquisa.removeListener(_pesquisar);
    _inputPesquisa.dispose();
    super.dispose();
  }
  List<Categoria> _lista = [];
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar categoria"),
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
        InputTextos("", "Digite para filtrar", controller: _inputPesquisa),
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom("Nenhum resultado", 18, Colors.red)
        else
          ..._lista.map((c) => CartaoConsulta(
                c.nome,
                ["Faixa etária: ${c.idadeMin} a ${c.idadeMax} anos"],
                icone: Icons.category,
                onTap: () => _editar(c),
              )),
      ],
    );
  }

  Future<void> _editar(Categoria c) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => TelaAdicionarCategoria(categoria: c)));
    _pesquisar();
  }

  Future<void> _pesquisar() async {
    try {
      ControlCategoria control = ControlCategoria();
      List<Categoria> lista = await control.queryFind(_inputPesquisa.text);

      setState(() {
        _lista = lista;
      });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
