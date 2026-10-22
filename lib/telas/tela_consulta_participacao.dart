import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_participacao.dart';
import 'package:projeto_final/model/participacao_jogador_time.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaParticipacao extends StatefulWidget {
  const TelaConsultaParticipacao({super.key});

  @override
  State<TelaConsultaParticipacao> createState() =>
      _TelaConsultaParticipacaoState();
}

class _TelaConsultaParticipacaoState extends State<TelaConsultaParticipacao> {
  String textoPesquisa = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar inscrições"),
        backgroundColor: Colors.orange,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Buttons("Pesquisar", onPressed: _pesquisar),
        TextosCustom(textoPesquisa, 18, Colors.red),
      ],
    );
  }

  Future _pesquisar() async {
    ControlParticipacao control = ControlParticipacao();
    List<ParticipacaoJogadorTime> lista = await control.queryFind();

    String texto = "";
    for (ParticipacaoJogadorTime p in lista) {
      texto +=
          "${p.id} - jogador: ${p.idJogador} - time: ${p.idTime} - camisa: ${p.numeroCamisa}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
