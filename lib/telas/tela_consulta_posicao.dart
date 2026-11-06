import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_posicao.dart';
import 'package:projeto_final/telas/tela_adicionar_posicao.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaPosicao extends StatefulWidget {
  const TelaConsultaPosicao({super.key});

  @override
  State<TelaConsultaPosicao> createState() => _TelaConsultaPosicaoState();
}

class _TelaConsultaPosicaoState extends State<TelaConsultaPosicao> {
  List<Map<String, dynamic>> _lista = [];
  final _inputPesquisa = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar posição"),
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
        InputTextos("", "Digite um nome para pesquisa", controller: _inputPesquisa),
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom("Nenhum resultado", 18, Colors.red)
        else
          ..._lista.map((p) => CartaoConsulta(
                p['nome'],
                ["Modalidade: ${p['nomeModalidade']}"],
                icone: Icons.pan_tool,
                onTap: () => _editar(p),
              )),
      ],
    );
  }

  Future<void> _editar(Map<String, dynamic> p) async {
    final lista = await ControlPosicao().queryFind();
    final pos = lista.firstWhere((x) => x.id == p['id'], orElse: () => lista.first);
    await Navigator.push(context, MaterialPageRoute(builder: (_) => TelaAdicionarPosicao(posicao: pos)));
    _pesquisar();
  }

  Future<void> _pesquisar() async {
    try {
      ControlPosicao control = ControlPosicao();
      List<Map<String, dynamic>> lista =
          await control.queryFindDetalhado(_inputPesquisa.text);

      setState(() {
        _lista = lista;
      });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
