import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_relatorio.dart';
import 'package:projeto_final/util/financeiro.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

/// Consulta de inscrições com o status financeiro do jogador (RNFR-13.3).
class TelaConsultaParticipacao extends StatefulWidget {
  const TelaConsultaParticipacao({super.key});

  @override
  State<TelaConsultaParticipacao> createState() =>
      _TelaConsultaParticipacaoState();
}

class _TelaConsultaParticipacaoState extends State<TelaConsultaParticipacao> {
  @override
  void initState() {
    super.initState();
    _pesquisar();
    _filtro.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _filtro.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _lista = [];
  final _filtro = TextEditingController();

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
    String f = _filtro.text.trim().toLowerCase();
    List<Map<String, dynamic>> filtrados = f.isEmpty
        ? _lista
        : _lista.where((item) => item.values.any((v) => v.toString().toLowerCase().contains(f))).toList();

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos("", "Digite para filtrar", controller: _filtro),
        SizedBox(height: 16),
        if (filtrados.isEmpty)
          TextosCustom("Nenhum resultado", 18, Colors.red)
        else
          ...filtrados.map(_cartao),
      ],
    );
  }

  // RNFR-13.3 — card com jogador, time, valores e status financeiro
  Widget _cartao(Map<String, dynamic> item) {
    double valorInscricao =
        (item['valorInscricao'] as num?)?.toDouble() ?? 0;
    double valorPago = (item['valorPago'] as num?)?.toDouble() ?? 0;

    String status = Financeiro.status(valorInscricao, valorPago);

    return CartaoConsulta(
      item['nomeJogador'] ?? "-",
      [
        "Time: ${item['nomeTime']} - Camisa: ${item['numeroCamisa'] ?? '-'}",
        "Inscrição: R\$ ${valorInscricao.toStringAsFixed(2)} - "
            "Pago: R\$ ${valorPago.toStringAsFixed(2)}",
      ],
      selo: status,
      corSelo: Financeiro.cor(status),
      icone: Icons.how_to_reg,
    );
  }

  Future _pesquisar() async {
    try {
    ControlRelatorio control = ControlRelatorio();
    List<Map<String, dynamic>> lista = await control.situacaoFinanceira();

    setState(() {
      _lista = lista;
    });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
