import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/control/control_pagamento.dart';
import 'package:projeto_final/control/control_participacao.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/model/pagamento_inscricao.dart';
import 'package:projeto_final/model/participacao_jogador_time.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';
import 'package:projeto_final/util/formatador.dart';

class TelaAdicionarPagamento extends StatefulWidget {
  final PagamentoInscricao? pagamento;
  const TelaAdicionarPagamento({super.key, this.pagamento});

  @override
  State<TelaAdicionarPagamento> createState() => _TelaAdicionarPagamentoState();
}

class _TelaAdicionarPagamentoState extends State<TelaAdicionarPagamento> {
  final _valorPago = TextEditingController();
  final _dataPagamento = TextEditingController();
  final _formaPagamento = TextEditingController();
  final _observacoes = TextEditingController();
  String? _idParticipacao;
  List<ParticipacaoJogadorTime> _participacoes = [];
  Map<int, String> _nomeJogador = {};
  String _resultado = "";
  int? _idEdicao;

  @override
  void initState() {
    super.initState();
    _carregarParticipacoes();
    if (widget.pagamento != null) {
      _idEdicao = widget.pagamento!.id;
    }
  }

  Future<void> _carregarParticipacoes() async {
    ControlParticipacao control = ControlParticipacao();
    List<ParticipacaoJogadorTime> lista = await control.queryFind();
    List<Jogador> jogs = await ControlJogador().queryFind();
    setState(() {
      _participacoes = lista;
      _nomeJogador = {for (final j in jogs) j.id!: j.nome};
      if (widget.pagamento != null) {
        _idParticipacao = widget.pagamento!.idParticipacao.toString();
        _valorPago.text = widget.pagamento!.valorPago.toString();
        _dataPagamento.text = Formatador.dataBr(widget.pagamento!.dataPagamento);
        _formaPagamento.text = widget.pagamento!.formaPagamento;
        _observacoes.text = widget.pagamento!.observacoes;
      } else {
        if (lista.isNotEmpty) _idParticipacao = lista[0].id.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar pagamento"),
        backgroundColor: Colors.green,
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
        DropdownButtonFormField<String>(
          initialValue: _idParticipacao,
          decoration: InputDecoration(
            labelText: "Inscrição do jogador",
            border: OutlineInputBorder(),
          ),
          items: _participacoes.map((p) {
            return DropdownMenuItem<String>(
              value: p.id.toString(),
              child: Text("Inscrição ${p.id} - ${_nomeJogador[p.idJogador] ?? 'jogador ${p.idJogador}'}"),
            );
          }).toList(),
          onChanged: (v) => setState(() => _idParticipacao = v),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InputTextos(
                "Valor pago",
                "0.00",
                controller: _valorPago,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InputTextos(
                "Data do pagamento",
                "dd/MM/yyyy",
                controller: _dataPagamento,
              ),
            ),
          ],
        ),
        InputTextos(
          "Forma de pagamento",
          "Ex: Dinheiro, Pix",
          controller: _formaPagamento,
        ),
        InputTextos("Observações", "Informe", controller: _observacoes),
        SizedBox(height: 8),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    PagamentoInscricao pagamento = PagamentoInscricao(
      idParticipacao: int.tryParse(_idParticipacao ?? "0") ?? 0,
      valorPago: double.tryParse(_valorPago.text) ?? 0,
      dataPagamento: Formatador.dataIso(_dataPagamento.text),
      formaPagamento: _formaPagamento.text,
      observacoes: _observacoes.text,
    );

    try {
      ControlPagamento control = ControlPagamento();
      if (_idEdicao != null) {
        PagamentoInscricao p = PagamentoInscricao(id: _idEdicao, idParticipacao: int.tryParse(_idParticipacao ?? "0") ?? 0, valorPago: double.tryParse(_valorPago.text) ?? 0, dataPagamento: Formatador.dataIso(_dataPagamento.text), formaPagamento: _formaPagamento.text, observacoes: _observacoes.text);
        await control.updateDatabase(p);
        setState(() => _resultado = "Pagamento atualizado!");
      } else {
        int id = await control.insertDatabase(pagamento);
        setState(() => _resultado = "Pagamento registrado! (id: $id)");
      }
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
