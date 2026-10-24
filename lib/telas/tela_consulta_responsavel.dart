import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_responsavel.dart';
import 'package:projeto_final/model/responsavel.dart';
import 'package:projeto_final/util/guarda_permissao.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
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
  List<Responsavel> _lista = [];
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
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom(
            textoPesquisa.isEmpty
                ? "Toque em pesquisar para listar os responsáveis."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map((r) => CartaoConsulta(
                r.nome,
                [
                  "CPF: ${r.cpf}",
                  if (r.telefone.trim().isNotEmpty) "Telefone: ${r.telefone}",
                  if (r.email.trim().isNotEmpty) "E-mail: ${r.email}",
                  "Parentesco: ${r.parentesco}",
                ],
                icone: Icons.family_restroom,
              )),
      ],
    );
  }

  Future _pesquisar() async {
    ControlResponsavel control = ControlResponsavel();
    List<Responsavel> lista = await control.queryFind(_inputPesquisa.text);

    setState(() {
      _lista = lista;
      textoPesquisa = lista.isEmpty ? "Nenhum responsável encontrado." : "";
    });
  }
}
