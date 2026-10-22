import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaClassificacao extends StatefulWidget {
  const TelaClassificacao({super.key});

  @override
  State<TelaClassificacao> createState() => _TelaClassificacaoState();
}

class _TelaClassificacaoState extends State<TelaClassificacao> {
  String _resultado = "";
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Classificação geral"),
        backgroundColor: Colors.purple,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Buttons("Gerar classificação", onPressed: _carregando ? null : () { _gerar(); }),
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
    List<Map<String, dynamic>> lista = await control.classificacaoGeral();

    String texto = "POS TIME              P   J   V   E   D   GP  GC  SG\n"
        "---------------------------------------------------------\n";

    int posicao = 1;
    for (Map<String, dynamic> item in lista) {
      String nome = (item['nomeTime'] as String).padRight(16);
      int pontos = item['pontos'] ?? 0;
      int jogos = item['jogos'] ?? 0;
      int vitorias = item['vitorias'] ?? 0;
      int empates = item['empates'] ?? 0;
      int derrotas = item['derrotas'] ?? 0;
      int golsPro = item['golsPro'] ?? 0;
      int golsContra = item['golsContra'] ?? 0;
      int saldo = golsPro - golsContra;

      texto += "${posicao.toString().padLeft(3)} $nome "
          "${pontos.toString().padLeft(3)} ${jogos.toString().padLeft(3)} "
          "${vitorias.toString().padLeft(3)} ${empates.toString().padLeft(3)} "
          "${derrotas.toString().padLeft(3)} ${golsPro.toString().padLeft(3)} "
          "${golsContra.toString().padLeft(3)} ${saldo.toString().padLeft(3)}\n";
      posicao++;
    }

    setState(() {
      _resultado = texto;
      _carregando = false;
    });
  }
}
