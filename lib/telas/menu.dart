import 'package:flutter/material.dart';
import 'package:projeto_final/telas/tela_adicionar_competicao.dart';
import 'package:projeto_final/telas/tela_consulta_competicao.dart';
import 'package:projeto_final/widgets/widget_button.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Competições Escolares"),
        backgroundColor: Colors.blue,
      ),
      body: _body(context),
    );
  }

  _body(BuildContext ctx) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Buttons(
            "Cadastrar",
            onPressed: () {
              _abreTelas(ctx, TelaAdicionarCompeticao());
            },
          ),
          Buttons(
            "Consultar",
            onPressed: () {
              _abreTelas(ctx, TelaConsultaCompeticao());
            },
          ),
        ],
      ),
    );
  }

  _abreTelas(ctx, page) {
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }),
    );
  }
}
