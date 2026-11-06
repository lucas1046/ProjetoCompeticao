import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_documento.dart';
import 'package:projeto_final/util/guarda_permissao.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaDocumento extends StatefulWidget {
  const TelaConsultaDocumento({super.key});

  @override
  State<TelaConsultaDocumento> createState() => _TelaConsultaDocumentoState();
}

class _TelaConsultaDocumentoState extends State<TelaConsultaDocumento> {
  List<Map<String, dynamic>> _lista = [];
  final _inputPesquisa = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    // RNFR-05.2 — documentos pessoais só para usuarios autorizados
    return GuardaPermissao(
      titulo: "Consultar documento",
      motivo: "Os documentos dos jogadores contêm dados pessoais e só "
          "podem ser vistos por administradores.",
      child: Scaffold(
        appBar: AppBar(
          title: Text("Consultar documento"),
          backgroundColor: Colors.orange,
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
        InputTextos("", "Digite um tipo de documento", controller: _inputPesquisa),
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom("Nenhum resultado", 18, Colors.red)
        else
          ..._lista.map((d) => CartaoConsulta(
                d['tipoDocumento'],
                [
                  "Jogador: ${d['nomeJogador']}",
                  "Arquivo: ${d['caminhoArquivo']}",
                ],
                icone: Icons.description,
              )),
      ],
    );
  }

  Future _pesquisar() async {
    try {
    ControlDocumento control = ControlDocumento();
    List<Map<String, dynamic>> lista =
        await control.queryFindDetalhado(_inputPesquisa.text);

    setState(() {
      _lista = lista;
    });
    } catch (_) {
      // banco indisponível (ex.: ambiente de teste) — mantém lista vazia
    }
  }
}
