import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_foto.dart';
import 'package:projeto_final/model/foto_figurinha.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';
import 'package:projeto_final/util/formatador.dart';

class TelaAdicionarFoto extends StatefulWidget {
  final FotoFigurinha? foto;
  const TelaAdicionarFoto({super.key, this.foto});

  @override
  State<TelaAdicionarFoto> createState() => _TelaAdicionarFotoState();
}

class _TelaAdicionarFotoState extends State<TelaAdicionarFoto> {
  final _caminhoArquivo = TextEditingController();
  final _dataUpload = TextEditingController();
  String _resultado = "";
  int? _idEdicao;

  @override
  void initState() {
    super.initState();
    if (widget.foto != null) {
      _idEdicao = widget.foto!.id;
      _caminhoArquivo.text = widget.foto!.caminhoArquivo;
      _dataUpload.text = Formatador.dataBr(widget.foto!.dataUpload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar foto"),
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
        InputTextos(
          "Caminho do arquivo",
          "Informe o caminho",
          controller: _caminhoArquivo,
        ),
        InputTextos("Data do upload", "dd/MM/yyyy", controller: _dataUpload),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _registrar() async {
    FotoFigurinha foto = FotoFigurinha(
      caminhoArquivo: _caminhoArquivo.text,
      dataUpload: Formatador.dataIso(_dataUpload.text),
    );

    try {
      ControlFoto control = ControlFoto();
      if (_idEdicao != null) {
        FotoFigurinha f = FotoFigurinha(id: _idEdicao, caminhoArquivo: _caminhoArquivo.text, dataUpload: Formatador.dataIso(_dataUpload.text));
        await control.updateDatabase(f);
        setState(() => _resultado = "Foto atualizada!");
      } else {
        int id = await control.insertDatabase(foto);
        setState(() => _resultado = "Foto cadastrada! (id: $id)");

        if (mounted) {

          await showDialog<void>(

            context: context,

            builder: (ctx) => AlertDialog(

              title: Text("Sucesso"),

              content: Text("Foto cadastrada! (id: $id)"),

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
