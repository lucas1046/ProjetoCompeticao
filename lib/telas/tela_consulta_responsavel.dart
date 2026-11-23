import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_responsavel.dart';
import 'package:projeto_final/telas/tela_adicionar_responsavel.dart';
import 'package:projeto_final/model/responsavel.dart';
import 'package:projeto_final/util/guarda_permissao.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaResponsavel extends StatefulWidget {
  const TelaConsultaResponsavel({super.key});

  @override
  State<TelaConsultaResponsavel> createState() =>
      _TelaConsultaResponsavelState();
}

class _TelaConsultaResponsavelState extends State<TelaConsultaResponsavel> {
  @override
  void initState() {
    super.initState();
    _pesquisar();
    _inputPesquisa.addListener(_pesquisar);
  }

  @override
  void dispose() {
    _inputPesquisa.removeListener(_pesquisar);
    _inputPesquisa.dispose();
    super.dispose();
  }
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
      ),
    );
  }

  ListView _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos("", "Digite para filtrar", controller: _inputPesquisa),
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom("Nenhum resultado", 18, Colors.red)
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
                onTap: () => _editar(r),
              )),
      ],
    );
  }

  Future<void> _editar(Responsavel r) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => TelaAdicionarResponsavel(responsavel: r)));
    _pesquisar();
  }

  Future<void> _pesquisar() async {
    try {
      ControlResponsavel control = ControlResponsavel();
      List<Responsavel> lista = await control.queryFind(_inputPesquisa.text);

      setState(() {
        _lista = lista;
      });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
