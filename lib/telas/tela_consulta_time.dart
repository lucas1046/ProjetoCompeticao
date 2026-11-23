import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_time.dart';
import 'package:projeto_final/telas/tela_adicionar_time.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaTime extends StatefulWidget {
  const TelaConsultaTime({super.key});

  @override
  State<TelaConsultaTime> createState() => _TelaConsultaTimeState();
}

class _TelaConsultaTimeState extends State<TelaConsultaTime> {
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
        title: Text("Consultar time"),
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
          ..._lista.map((t) => CartaoConsulta(
                t['nomeTime'],
                [
                  "Escola: ${t['nomeEscola']}",
                  "Categoria: ${t['nomeCategoria']}",
                ],
                icone: Icons.groups,
                onTap: () => _editar(t),
              )),
      ],
    );
  }

  Future<void> _editar(Map<String, dynamic> t) async {
    final times = await ControlTime().queryFind();
    final time = times.firstWhere((x) => x.idTime == t['idTime'], orElse: () => times.first);
    if (!mounted) return;
    await Navigator.push(context, MaterialPageRoute(builder: (_) => TelaAdicionarTime(time: time)));
    _pesquisar();
  }

  Future<void> _pesquisar() async {
    try {
      ControlTime control = ControlTime();
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
