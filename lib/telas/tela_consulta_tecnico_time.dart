import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_tecnico_time.dart';
import 'package:projeto_final/model/tecnico_time.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaConsultaTecnicoTime extends StatefulWidget {
  const TelaConsultaTecnicoTime({super.key});

  @override
  State<TelaConsultaTecnicoTime> createState() =>
      _TelaConsultaTecnicoTimeState();
}

class _TelaConsultaTecnicoTimeState extends State<TelaConsultaTecnicoTime> {
  String textoPesquisa = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar técnicos por time"),
        backgroundColor: Colors.orange,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Buttons("Pesquisar", onPressed: _pesquisar),
        TextosCustom(textoPesquisa, 18, Colors.red),
      ],
    );
  }

  Future _pesquisar() async {
    ControlTecnicoTime control = ControlTecnicoTime();
    List<TecnicoTime> lista = await control.queryFind();

    String texto = "";
    for (TecnicoTime t in lista) {
      texto += "${t.idTecnicoTime} - técnico: ${t.idTecnico} - time: ${t.idTime}\n";
    }

    setState(() {
      textoPesquisa = texto;
    });
  }
}
