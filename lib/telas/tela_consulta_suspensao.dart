import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_suspensao.dart';
import 'package:projeto_final/model/suspensao.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaSuspensao extends StatefulWidget {
  const TelaConsultaSuspensao({super.key});

  @override
  State<TelaConsultaSuspensao> createState() => _TelaConsultaSuspensaoState();
}

class _TelaConsultaSuspensaoState extends State<TelaConsultaSuspensao> {
  String textoPesquisa = "";
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar suspensões"),
        backgroundColor: Colors.orange,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos(
          "",
          "Digite um motivo para pesquisa",
          controller: _inputPesquisa,
        ),
        Buttons("Pesquisar", onPressed: _pesquisar),
        TextosCustom(textoPesquisa, 18, Colors.red),
      ],
    );
  }

  Future _pesquisar() async {
    ControlSuspensao control = ControlSuspensao();
    List<Suspensao> lista = await control.queryFind(_inputPesquisa.text);

    String texto = "";
    for (Suspensao s in lista) {
      texto += "${s.id} - ${s.motivo} - ${s.qtdJogosSuspensao} jogo(s) - "
          "cumprida: ${s.cumprida ? 'Sim' : 'Não'}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
