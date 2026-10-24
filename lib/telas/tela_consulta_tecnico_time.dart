import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_tecnico_time.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
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
  List<Map<String, dynamic>> _lista = [];

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
        SizedBox(height: 16),
        if (_lista.isEmpty)
          TextosCustom(
            textoPesquisa.isEmpty
                ? "Toque em pesquisar para listar os vínculos."
                : textoPesquisa,
            18,
            Colors.red,
          )
        else
          ..._lista.map((v) => CartaoConsulta(
                v['nomeTime'],
                ["Técnico: ${v['nomeTecnico']}"],
                icone: Icons.link,
              )),
      ],
    );
  }

  Future _pesquisar() async {
    ControlTecnicoTime control = ControlTecnicoTime();
    List<Map<String, dynamic>> lista = await control.queryFindDetalhado();

    setState(() {
      _lista = lista;
      textoPesquisa =
          lista.isEmpty ? "Nenhum técnico vinculado a time." : "";
    });
  }
}
