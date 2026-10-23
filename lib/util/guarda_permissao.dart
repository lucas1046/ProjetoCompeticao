import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_sessao.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

/// RNFR-15.2, RNFR-05.2 e RNFR-16.2 — envolve uma tela que só pode ser
/// acessada por usuarios com perfil de administrador. Quando o usuario
/// logado nao tem o perfil, mostra o aviso em vez do conteudo.
class GuardaPermissao extends StatelessWidget {
  final String titulo;
  final String motivo;
  final Widget child;

  const GuardaPermissao({
    super.key,
    required this.titulo,
    required this.motivo,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (ControlSessao().isAdministrador) {
      return child;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: Colors.grey,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Icon(Icons.lock_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          TextosCustom("Acesso restrito", 22, Colors.red),
          SizedBox(height: 8),
          TextosCustom(motivo, 16, Colors.black),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextosCustom(
                  "Perfil da sessão: ${ControlSessao().usuario?.perfil ?? '—'}",
                  14,
                  Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
