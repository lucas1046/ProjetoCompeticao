import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/telas/tela_adicionar_evento.dart';
import 'package:projeto_final/telas/tela_consulta_evento.dart';
import 'package:projeto_final/telas/tela_adicionar_tipo_evento.dart';
import 'package:projeto_final/telas/tela_consulta_tipo_evento.dart';
import 'package:projeto_final/telas/tela_adicionar_posicao.dart';
import 'package:projeto_final/telas/tela_consulta_posicao.dart';
import 'package:projeto_final/telas/tela_detalhe_entidade.dart';

/// Menu de configurações (mesmo layout dos relatórios).
class MenuConfiguracoes extends StatelessWidget {
  const MenuConfiguracoes({super.key});

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
      body: _body(context),
    );
  }

  ListView _body(BuildContext ctx) {
    final opcoes = [
      _Opcao("Tipo de evento", Icons.flag, () => TelaAdicionarTipoEvento(),
          () => TelaConsultaTipoEvento()),
      _Opcao("Evento", Icons.timer, () => TelaAdicionarEvento(),
          () => TelaConsultaEvento()),
      _Opcao("Posição", Icons.pan_tool, () => TelaAdicionarPosicao(),
          () => TelaConsultaPosicao()),
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: opcoes.length,
      itemBuilder: (context, index) {
        final opcao = opcoes[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(opcao.icone, size: 32, color: Colors.blue),
            title: Text(
              opcao.titulo,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _abre(ctx, opcao),
          ),
        );
      },
    );
  }

  void _abre(BuildContext ctx, _Opcao opcao) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => TelaDetalheEntidade(
          titulo: opcao.titulo,
          icone: opcao.icone,
          telaCadastro: opcao.abreCadastro(),
          telaConsulta: opcao.abreConsulta(),
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