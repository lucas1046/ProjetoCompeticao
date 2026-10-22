import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaRelatorioSuspensos extends StatefulWidget {
  const TelaRelatorioSuspensos({super.key});

  @override
  State<TelaRelatorioSuspensos> createState() => _TelaRelatorioSuspensosState();
}

class _TelaRelatorioSuspensosState extends State<TelaRelatorioSuspensos> {
  String _resultado = "";
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jogadores suspensos"),
        backgroundColor: Colors.purple,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Buttons("Gerar relatório", onPressed: _carregando ? null : () { _gerar(); }),
        SizedBox(height: 16),
        if (_carregando) Center(child: CircularProgressIndicator()),
        TextosCustom(_resultado, 16, Colors.black),
      ],
    );
  }

  Future _gerar() async {
    setState(() {
      _carregando = true;
      _resultado = "";
    });

    ControlRelatorio control = ControlRelatorio();
    List<Map<String, dynamic>> lista = await control.jogadoresSuspensos();

    String texto = "JOGADOR              TIME        MOTIVO               JOGOS\n"
        "--------------------------------------------------------------\n";

    for (Map<String, dynamic> s in lista) {
      String nome = (s['nomeJogador'] as String).padRight(18);
      String time = (s['nomeTime'] as String).padRight(10);
      String motivo = (s['motivo'] as String).padRight(20);
      int jogos = s['qtdJogos'] as int? ?? 0;

      texto += "$nome $time $motivo ${jogos.toString().padLeft(4)}\n";
    }

    if (lista.isEmpty) {
      texto += "Nenhum jogador suspenso no momento.\n";
    }

    setState(() {
      _resultado = texto;
      _carregando = false;
    });
  }
}
