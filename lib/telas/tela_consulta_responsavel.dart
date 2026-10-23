import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_responsavel.dart';
import 'package:projeto_final/model/responsavel.dart';
import 'package:projeto_final/util/guarda_permissao.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaResponsavel extends StatefulWidget {
  const TelaConsultaResponsavel({super.key});

  @override
  State<TelaConsultaResponsavel> createState() =>
      _TelaConsultaResponsavelState();
}

class _TelaConsultaResponsavelState extends State<TelaConsultaResponsavel> {
  String textoPesquisa = "";
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // RNFR-16.2 — dados pessoais dos responsáveis só para perfis autorizados
    return GuardaPermissao(
      titulo: "Consultar responsável",
      motivo: "Os dados dos responsáveis têm acesso restrito e só podem "
          "ser vistos por administradores.",
      child: Scaffold(
        appBar: AppBar(
          title: Text("Consultar responsável"),
          backgroundColor: Colors.orange,
        ),
        body: _body(),
      ),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos(
          "",
          "Digite um nome para pesquisa",
          controller: _inputPesquisa,
        ),
        Buttons("Pesquisar", onPressed: _pesquisar),
        TextosCustom(textoPesquisa, 18, Colors.red),
      ],
    );
  }

  Future _pesquisar() async {
    ControlResponsavel control = ControlResponsavel();
    List<Responsavel> lista = await control.queryFind(_inputPesquisa.text);

    String texto = "";
    for (Responsavel r in lista) {
      texto += "${r.id} - ${r.nome} - ${r.cpf} - ${r.parentesco}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
