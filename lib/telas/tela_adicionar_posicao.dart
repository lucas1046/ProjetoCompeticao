import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_modalidade.dart';
import 'package:projeto_final/control/control_posicao.dart';
import 'package:projeto_final/model/modalidade.dart';
import 'package:projeto_final/model/posicao.dart';
import 'package:projeto_final/widgets/widget_autocomplete.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarPosicao extends StatefulWidget {
  final Posicao? posicao;
  const TelaAdicionarPosicao({super.key, this.posicao});

  @override
  State<TelaAdicionarPosicao> createState() => _TelaAdicionarPosicaoState();
}

class _TelaAdicionarPosicaoState extends State<TelaAdicionarPosicao> {
  final _nome = TextEditingController();
  String? _idModalidadeSelecionada;
  List<Modalidade> _modalidades = [];
  String _resultado = "";
  int? _idEdicao;

  @override
  void initState() {
    super.initState();
    _carregarModalidades();
    if (widget.posicao != null) {
      _idEdicao = widget.posicao!.id;
      _nome.text = widget.posicao!.nome;
      _idModalidadeSelecionada = widget.posicao!.idModalidade.toString();
    }
  }

  Future<void> _carregarModalidades() async {
    ControlModalidade control = ControlModalidade();
    List<Modalidade> lista = await control.queryFind();
    setState(() {
      _modalidades = lista;
      if (widget.posicao == null && lista.isNotEmpty && _idModalidadeSelecionada == null) {
        _idModalidadeSelecionada = lista[0].id.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar posição"),
        backgroundColor: Colors.green,
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
      body: _body(),
    );
  }

  ListView _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InputTextos("Digite o nome", "Ex: Goleiro, Zagueiro", controller: _nome),
        WidgetAutocomplete(
          rotulo: "Modalidade",
          itens: _modalidades.map((m) => AutocompleteItem(m.id.toString(), m.nome)).toList(),
          initialValue: _idModalidadeSelecionada,
          onSelected: (valor) {
            setState(() {
              _idModalidadeSelecionada = valor?.toString();
            });
          },
        ),
        SizedBox(height: 16),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    Posicao posicao = Posicao(
      nome: _nome.text,
      idModalidade: int.tryParse(_idModalidadeSelecionada ?? "0") ?? 0,
    );

    try {
      ControlPosicao control = ControlPosicao();
      if (_idEdicao != null) {
        Posicao p = Posicao(id: _idEdicao, nome: _nome.text, idModalidade: int.tryParse(_idModalidadeSelecionada ?? "0") ?? 0);
        await control.updateDatabase(p);
        setState(() => _resultado = "Posição ${p.nome} atualizada!");
      } else {
        int id = await control.insertDatabase(posicao);
        setState(() => _resultado = "Posição ${posicao.nome} cadastrada! (id: $id)");

        if (mounted) {

          await showDialog<void>(

            context: context,

            builder: (ctx) => AlertDialog(

              title: Text("Sucesso"),

              content: Text("Posição ${posicao.nome} cadastrada! (id: $id)"),

              actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text("OK"))],

            ),

          );

          if (mounted) Navigator.pop(context);

        }
      }
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
