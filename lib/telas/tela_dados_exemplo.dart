import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_dados_exemplo.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaDadosExemplo extends StatefulWidget {
  const TelaDadosExemplo({super.key});

  @override
  State<TelaDadosExemplo> createState() => _TelaDadosExemploState();
}

class _TelaDadosExemploState extends State<TelaDadosExemplo> {
  String _resultado = "";
  bool _carregando = false;
  bool _vazio = false;

  @override
  void initState() {
    super.initState();
    _verificarBanco();
  }

  Future<void> _verificarBanco() async {
    ControlDadosExemplo control = ControlDadosExemplo();
    bool vazio = await control.bancoVazio();
    setState(() {
      _vazio = vazio;
      _resultado = vazio
          ? "O banco está vazio. Toque em GERAR para criar os dados de exemplo."
          : "O banco já possui dados. Você pode gerar novamente (serão ignorados os conflitos de chave).";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dados de exemplo"),
        backgroundColor: Colors.indigo,
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

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          "Esta tela cria dados de teste para facilitar a avaliação do sistema.",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
        if (_vazio)
          Card(
            color: Colors.amber.shade100,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Banco vazio detectado. Gere os dados para testar os cadastros e relatórios.",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        SizedBox(height: 16),
        Buttons("Gerar dados de exemplo", onPressed: _carregando ? null : () { _gerar(); }),
        SizedBox(height: 16),
        if (_carregando) Center(child: CircularProgressIndicator()),
        TextosCustom(_resultado, 16, Colors.black),
      ],
    );
  }

  Future _gerar() async {
    setState(() {
      _carregando = true;
      _resultado = "Gerando dados...";
    });

    try {
      ControlDadosExemplo control = ControlDadosExemplo();
      String mensagem = await control.popular();

      setState(() {
        _resultado = "$mensagem\n\n"
            "Agora teste:\n"
            "- Consultas de cada entidade\n"
            "- Relatórios -> Classificação geral\n"
            "- Relatórios -> Estatísticas do jogador\n"
            "- Relatórios -> Relatório financeiro\n"
            "- Relatórios -> Jogadores suspensos";
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _resultado = "Erro ao gerar dados: $e";
        _carregando = false;
      });
    }
  }
}
