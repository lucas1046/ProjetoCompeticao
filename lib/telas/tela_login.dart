import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_sessao.dart';
import 'package:projeto_final/control/control_usuario.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

/// Tela de login (RNFR-15.2). E o ponto de entrada do app.
class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _login = TextEditingController();
  final _senha = TextEditingController();
  String _resultado = "";
  bool _carregando = false;

  static const Color corDominante = Color(0xFFF31A2E);
  static const Color corSecundaria = Color(0xFF0462C3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Competições Escolares"),
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
      body: _body(),
    );
  }

  ListView _body() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextosCustom("Acesso ao sistema", 22, corDominante),
        const SizedBox(height: 16),
        InputTextos("Login", "Informe o login", controller: _login),
        const SizedBox(height: 12),
        InputTextos(
          "Senha",
          "Informe a senha",
          controller: _senha,
          senha: true,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Buttons(
                "Entrar",
                onPressed: _carregando ? null : _entrar,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_carregando) const Center(child: CircularProgressIndicator()),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _entrar() async {
    setState(() {
      _carregando = true;
      _resultado = "";
    });

    try {
      ControlUsuario control = ControlUsuario();
      var usuario = await control.autenticar(_login.text, _senha.text);

      ControlSessao().entrar(usuario);

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const Menu()),
      );
    } catch (e) {
      setState(() {
        _resultado = e.toString();
        _carregando = false;
      });
    }
  }
}
