import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/telas/tela_adicionar_evento.dart';
import 'package:projeto_final/telas/tela_consulta_evento.dart';
import 'package:projeto_final/telas/tela_adicionar_tipo_evento.dart';
import 'package:projeto_final/telas/tela_consulta_tipo_evento.dart';
import 'package:projeto_final/telas/tela_adicionar_posicao.dart';
import 'package:projeto_final/telas/tela_consulta_posicao.dart';
import 'package:projeto_final/telas/tela_detalhe_entidade.dart';

class MenuConfiguracoes extends StatefulWidget {
  const MenuConfiguracoes({super.key});

  @override
  State<MenuConfiguracoes> createState() => _MenuConfiguracoesState();
}

class _MenuConfiguracoesState extends State<MenuConfiguracoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        backgroundColor: Colors.blue,
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
      body: _grid(context),
    );
  }

  _grid(BuildContext ctx) {
    final opcoes = [
      _Opcao("Tipo de evento", Icons.flag, () => TelaAdicionarTipoEvento(),
          () => TelaConsultaTipoEvento()),
      _Opcao("Evento", Icons.timer, () => TelaAdicionarEvento(),
          () => TelaConsultaEvento()),
      _Opcao("Posição", Icons.pan_tool, () => TelaAdicionarPosicao(),
          () => TelaConsultaPosicao()),
    ];

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: opcoes.length,
      itemBuilder: (context, index) {
        final opcao = opcoes[index];
        return Card(
          elevation: 3,
          child: InkWell(
            onTap: () => _abre(ctx, opcao),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(opcao.icone, size: 36, color: Colors.blue),
                  SizedBox(height: 8),
                  Text(
                    opcao.titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _abre(BuildContext ctx, _Opcao opcao) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => TelaDetalheEntidade(
          titulo: opcao.titulo,
          icone: opcao.icone,
          telaCadastro: opcao.abreCadastro!(),
          telaConsulta: opcao.abreConsulta!(),
        ),
      ),
    );
  }
}

class _Opcao {
  final String titulo;
  final IconData icone;
  final Function() abreCadastro;
  final Function() abreConsulta;

  _Opcao(this.titulo, this.icone, this.abreCadastro, this.abreConsulta);
}