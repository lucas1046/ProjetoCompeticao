import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_sessao.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/telas/tela_login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Competições Escolares',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // RNFR-15.2 — sem usuario autenticado o app abre na tela de login
      home: ControlSessao().logado ? Menu() : TelaLogin(),
    );
  }
}
