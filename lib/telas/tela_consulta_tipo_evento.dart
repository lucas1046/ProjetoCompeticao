import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_tipo_evento.dart';
import 'package:projeto_final/telas/tela_adicionar_tipo_evento.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaTipoEvento extends StatefulWidget {
  const TelaConsultaTipoEvento({super.key});

  @override
  State<TelaConsultaTipoEvento> createState() => _TelaConsultaTipoEventoState();
}

class _TelaConsultaTipoEventoState extends State<TelaConsultaTipoEvento> {
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
  List<TipoEvento> _lista = [];
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar tipo de evento"),
        backgroundColor: Colors.orange,
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
          "",
          "Digite uma descrição para pesquisa",
          controller: _inputPesquisa,
        ),
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom("Nenhum resultado", 18, Colors.red)
        else
          ..._lista.map((t) => CartaoConsulta(
                t.descricao,
                ["Id: ${t.id}"],
                icone: Icons.flag,
                onTap: () => _editar(t),
              )),
      ],
    );
  }

  Future<void> _editar(TipoEvento t) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => TelaAdicionarTipoEvento(tipoEvento: t)));
    _pesquisar();
  }

  Future<void> _pesquisar() async {
    try {
      ControlTipoEvento control = ControlTipoEvento();
      List<TipoEvento> lista = await control.queryFind(_inputPesquisa.text);

      setState(() {
        _lista = lista;
      });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
