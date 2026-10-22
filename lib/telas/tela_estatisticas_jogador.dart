import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_participacao.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/model/participacao_jogador_time.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaEstatisticasJogador extends StatefulWidget {
  const TelaEstatisticasJogador({super.key});

  @override
  State<TelaEstatisticasJogador> createState() =>
      _TelaEstatisticasJogadorState();
}

class _TelaEstatisticasJogadorState extends State<TelaEstatisticasJogador> {
  String? _idParticipacao;
  List<ParticipacaoJogadorTime> _participacoes = [];
  String _resultado = "";
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarParticipacoes();
  }

  Future<void> _carregarParticipacoes() async {
    ControlParticipacao control = ControlParticipacao();
    List<ParticipacaoJogadorTime> lista = await control.queryFind();
    setState(() {
      _participacoes = lista;
      if (lista.isNotEmpty) {
        _idParticipacao = lista[0].id.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Estatísticas do jogador"),
        backgroundColor: Colors.purple,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          value: _idParticipacao,
          decoration: InputDecoration(
            labelText: "Jogador inscrito",
            border: OutlineInputBorder(),
          ),
          items: _participacoes.map((p) {
            return DropdownMenuItem<String>(
              value: p.id.toString(),
              child: Text("Inscrição ${p.id} - camisa ${p.numeroCamisa}"),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idParticipacao = v),
        ),
        SizedBox(height: 16),
        Buttons("Consultar", onPressed: _carregando ? null : () { _consultar(); }),
        SizedBox(height: 16),
        if (_carregando) Center(child: CircularProgressIndicator()),
        TextosCustom(_resultado, 18, Colors.black),
      ],
    );
  }

  Future _consultar() async {
    if (_idParticipacao == null) {
      setState(() {
        _resultado = "Nenhuma inscrição encontrada.";
      });
      return;
    }

    setState(() {
      _carregando = true;
      _resultado = "";
    });

    int idParticipacao = int.parse(_idParticipacao!);
    ControlRelatorio control = ControlRelatorio();

    List<Map<String, dynamic>> eventos =
        await control.estatisticasPorTipo(idParticipacao);
    int craques = await control.totalCraques(idParticipacao);
    int jogos = await control.totalJogos(idParticipacao);

    String texto = "Jogos participados: $jogos\n"
        "Craque da partida: $craques vez(es)\n\n"
        "Eventos em campo:\n";

    if (eventos.isEmpty) {
      texto += "  Nenhum evento registrado\n";
    } else {
      for (Map<String, dynamic> e in eventos) {
        texto += "  ${e['tipo']}: ${e['total']}\n";
      }
    }

    setState(() {
      _resultado = texto;
      _carregando = false;
    });
  }
}
