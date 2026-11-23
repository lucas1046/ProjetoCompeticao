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

  static const Color corDominante = Color(0xFFF31A2E);
  static const Color corSecundaria = Color(0xFF0462C3);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Competições Escolares',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: corDominante,
          primary: corDominante,
          secondary: corSecundaria,
        ),
        primaryColor: corDominante,
        appBarTheme: const AppBarTheme(
          backgroundColor: corDominante,
          foregroundColor: Colors.white,
          centerTitle: false,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: corDominante,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      // RNFR-15.2 — sem usuario autenticado o app abre na tela de login
      home: ControlSessao().logado ? Menu() : TelaLogin(),
    );
  }
}
