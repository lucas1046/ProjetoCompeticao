import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

/// Tela de detalhe de uma entidade: menu -> entidade -> ação.
/// Uma única tela genérica atende as 20 entidades de CRUD.
class TelaDetalheEntidade extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Widget telaCadastro;
  final Widget telaConsulta;

  static const Color corDominante = Color(0xFFF31A2E);
  static const Color corSecundaria = Color(0xFF0462C3);

  const TelaDetalheEntidade({
    super.key,
    required this.titulo,
    required this.icone,
    required this.telaCadastro,
    required this.telaConsulta,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: corDominante,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Menu()),
              (_) => false,
            ),
          ),
        ],
      ),
      body: _body(context),
    );
  }

  ListView _body(BuildContext ctx) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _cabecalho(),
        const SizedBox(height: 24),
        // RNFR-15.2 — a tela em si nao tem restricao; a tela de destino cuida disso
        Row(
          children: [
            Expanded(
              child: Buttons("Cadastrar", onPressed: () => _abrir(ctx, telaCadastro)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Buttons("Consultar", onPressed: () => _abrir(ctx, telaConsulta)),
            ),
          ],
        ),
      ],
    );
  }

  // Icone grande centralizado logo abaixo do AppBar
  Column _cabecalho() {
    return Column(
      children: [
        const SizedBox(height: 24),
        CircleAvatar(
          radius: 48,
          backgroundColor: corSecundaria.withOpacity(0.12),
          child: Icon(icone, size: 52, color: corSecundaria),
        ),
        const SizedBox(height: 16),
        TextosCustom(titulo, 22, corDominante),
        const SizedBox(height: 8),
        TextosCustom(
          "Escolha entre cadastrar um novo registro ou consultar os já cadastrados.",
          14,
          Colors.grey,
        ),
      ],
    );
  }

  void _abrir(BuildContext ctx, Widget page) {
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (BuildContext context) => page),
    );
  }
}
