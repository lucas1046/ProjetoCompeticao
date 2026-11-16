import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_escola.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/control/control_responsavel.dart';
import 'package:projeto_final/control/control_participacao.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/model/participacao_jogador_time.dart';
import 'package:projeto_final/control/control_foto.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/model/foto_figurinha.dart';
import 'package:projeto_final/model/responsavel.dart';
import 'package:projeto_final/widgets/widget_autocomplete.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';
import 'package:projeto_final/util/formatador.dart';

class TelaAdicionarJogador extends StatefulWidget {
  final Jogador? jogador;
  const TelaAdicionarJogador({super.key, this.jogador});

  @override
  State<TelaAdicionarJogador> createState() => _TelaAdicionarJogadorState();
}

class _TelaAdicionarJogadorState extends State<TelaAdicionarJogador> {
  final _nome = TextEditingController();
  final _cpf = TextEditingController();
  final _dataNascimento = TextEditingController();
  final _valorInscricao = TextEditingController();
  String? _idResponsavelSelecionado;
  String? _idFotoSelecionada;
  String? _idEscolaSelecionada;
  List<Responsavel> _responsaveis = [];
  List<FotoFigurinha> _fotos = [];
  List<Escola> _escolas = [];
  String _resultado = "";
  int? _idEdicao;

  @override
  void initState() {
    super.initState();
    _carregarResponsaveis();
    _carregarFotos();
    _carregarEscolas();
    if (widget.jogador != null) {
      _idEdicao = widget.jogador!.id;
      _nome.text = widget.jogador!.nome;
      _cpf.text = widget.jogador!.cpf;
      _dataNascimento.text = Formatador.dataBr(widget.jogador!.dataNascimento);
      if (widget.jogador!.idResponsavel != 0) {
        _idResponsavelSelecionado = widget.jogador!.idResponsavel.toString();
      }
      if (widget.jogador!.idFoto != null) {
        _idFotoSelecionada = widget.jogador!.idFoto.toString();
      }
      if (widget.jogador!.idEscola != null) {
        _idEscolaSelecionada = widget.jogador!.idEscola.toString();
      }
      if (widget.jogador!.id != null) {
        _carregarInscricao(widget.jogador!.id!);
      }
    }
  }

  Future<void> _carregarInscricao(int idJogador) async {
    final participacoes = await ControlParticipacao().queryFind();
    final list = participacoes.where((x) => x.idJogador == idJogador).toList();
    if (list.isNotEmpty) {
      final p = list.first;
      setState(() {
        if (p.valorInscricao != null) {
          _valorInscricao.text = p.valorInscricao!.toStringAsFixed(2);
        }
        if (_idEscolaSelecionada == null && p.idEscola != null) {
          _idEscolaSelecionada = p.idEscola.toString();
        }
      });
    }
  }

  Future<void> _carregarResponsaveis() async {
    ControlResponsavel control = ControlResponsavel();
    List<Responsavel> lista = await control.queryFind();
    setState(() {
      _responsaveis = lista;
      if (widget.jogador == null && lista.isNotEmpty && _idResponsavelSelecionado == null) {
        _idResponsavelSelecionado = lista[0].id.toString();
      }
    });
  }

  Future<void> _carregarFotos() async {
    final lista = await ControlFoto().queryFind();
    setState(() {
      _fotos = lista;
      if (widget.jogador == null && lista.isNotEmpty && _idFotoSelecionada == null) {
        _idFotoSelecionada = lista[0].id.toString();
      }
    });
  }

  Future<void> _carregarEscolas() async {
    final lista = await ControlEscola().queryFind();
    setState(() {
      _escolas = lista;
      if (widget.jogador == null && lista.isNotEmpty && _idEscolaSelecionada == null) {
        _idEscolaSelecionada = lista[0].id.toString();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar jogador"),
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
        InputTextos("Digite o nome", "Informe o nome", controller: _nome),
        Row(
          children: [
            Expanded(
              child: InputTextos("Digite o CPF", "Informe o CPF", controller: _cpf),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InputTextos(
                "Data de nascimento",
                "dd/MM/yyyy",
                controller: _dataNascimento,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: WidgetAutocomplete(
                rotulo: "Responsável legal",
                itens: _responsaveis.map((r) => AutocompleteItem(r.id.toString(), r.nome)).toList(),
                initialValue: _idResponsavelSelecionado,
                onSelected: (valor) {
                  setState(() {
                    _idResponsavelSelecionado = valor?.toString();
                  });
                },
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              tooltip: "Novo responsável",
              icon: Icon(Icons.add_circle, color: Colors.green),
              onPressed: _novoResponsavel,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: WidgetAutocomplete(
                rotulo: "Foto (opcional)",
                itens: _fotos.map((f) => AutocompleteItem(f.id.toString(), f.caminhoArquivo.split('/').last)).toList(),
                initialValue: _idFotoSelecionada,
                onSelected: (valor) {
                  setState(() {
                    _idFotoSelecionada = valor?.toString();
                  });
                },
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              tooltip: "Nova foto",
              icon: Icon(Icons.add_circle, color: Colors.green),
              onPressed: _novaFoto,
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: WidgetAutocomplete(
              rotulo: "Escola (origem)",
              itens: _escolas.map((e) => AutocompleteItem(e.id.toString(), e.nome)).toList(),
              initialValue: _idEscolaSelecionada,
              onSelected: (v) => setState(() => _idEscolaSelecionada = v?.toString()),
            )),
            IconButton(tooltip: "Nova escola", icon: Icon(Icons.add_circle, color: Colors.green), onPressed: _novaEscola),
          ],
        ),
        SizedBox(height: 8),
        InputTextos("Valor da inscrição", "0.00", controller: _valorInscricao),
        SizedBox(height: 16),
        Buttons("Registrar", onPressed: _registrar),
        TextosCustom(_resultado, 18, Colors.red),
      ],
    );
  }

  Future<void> _novoResponsavel() async {
    final nomeCtrl = TextEditingController();
    final cpfCtrl = TextEditingController();
    final telCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final parentCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Novo responsável"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomeCtrl, decoration: InputDecoration(labelText: "Nome")),
              SizedBox(height: 8),
              TextField(controller: cpfCtrl, decoration: InputDecoration(labelText: "CPF")),
              SizedBox(height: 8),
              TextField(controller: telCtrl, decoration: InputDecoration(labelText: "Telefone")),
              SizedBox(height: 8),
              TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Email")),
              SizedBox(height: 8),
              TextField(controller: parentCtrl, decoration: InputDecoration(labelText: "Parentesco")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Salvar")),
        ],
      ),
    );

    if (ok != true) return;

    try {
      final r = Responsavel(
        nome: nomeCtrl.text,
        cpf: cpfCtrl.text,
        telefone: telCtrl.text,
        email: emailCtrl.text,
        parentesco: parentCtrl.text,
      );
      await ControlResponsavel().insertDatabase(r);
      await _carregarResponsaveis();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Responsável criado.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _novaFoto() async {
    final pathCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Nova foto"),
        content: TextField(controller: pathCtrl, decoration: InputDecoration(labelText: "Caminho do arquivo")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Salvar")),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final f = FotoFigurinha(caminhoArquivo: pathCtrl.text, dataUpload: DateTime.now().toIso8601String().substring(0, 10));
      final id = await ControlFoto().insertDatabase(f);
      await _carregarFotos();
      setState(() => _idFotoSelecionada = id.toString());
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Foto criada.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  Future<void> _novaEscola() async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: Text("Nova escola"), content: TextField(controller: ctrl, decoration: InputDecoration(labelText: "Nome")), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar")), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Salvar"))]));
    if (ok != true || ctrl.text.trim().isEmpty) return;
    try {
      await ControlEscola().insertDatabase(Escola(nome: ctrl.text.trim(), cidade: "", estado: "", telefone: ""));
      await _carregarEscolas();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Escola criada.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _registrar() async {
    Jogador jogador = Jogador(
      nome: _nome.text,
      cpf: _cpf.text,
      dataNascimento: Formatador.dataIso(_dataNascimento.text),
      idResponsavel: int.tryParse(_idResponsavelSelecionado ?? "0") ?? 0,
      idFoto: int.tryParse(_idFotoSelecionada ?? ""),
      idEscola: int.tryParse(_idEscolaSelecionada ?? ""),
    );

    try {
      ControlJogador control = ControlJogador();
      int idJogador;
      if (_idEdicao != null) {
        Jogador j = Jogador(id: _idEdicao, nome: _nome.text, cpf: _cpf.text, dataNascimento: Formatador.dataIso(_dataNascimento.text), idResponsavel: int.tryParse(_idResponsavelSelecionado ?? "0") ?? 0, idFoto: int.tryParse(_idFotoSelecionada ?? ""), idEscola: int.tryParse(_idEscolaSelecionada ?? ""));
        await control.updateDatabase(j);
        idJogador = _idEdicao!;
        setState(() => _resultado = "Jogador ${j.nome} atualizado!");
      } else {
        idJogador = await control.insertDatabase(jogador);
        setState(() => _resultado = "Jogador ${jogador.nome} cadastrado! (id: $idJogador)");

        if (mounted) {

          await showDialog<void>(

            context: context,

            builder: (ctx) => AlertDialog(

              title: Text("Sucesso"),

              content: Text("Jogador ${jogador.nome} cadastrado! (id: $idJogador)"),

              actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text("OK"))],

            ),

          );

          if (mounted) Navigator.pop(context);

        }
      }
      // inscricao integrada
      if (_idEscolaSelecionada != null) {
        final part = ParticipacaoJogadorTime(
          idJogador: idJogador,
          idEscola: int.tryParse(_idEscolaSelecionada ?? "0"),
          valorInscricao: double.tryParse(_valorInscricao.text),
        );
        final existentes = await ControlParticipacao().queryFind();
        final vinc = existentes.where((p) => p.idJogador == idJogador).toList();
        if (vinc.isNotEmpty) {
          await ControlParticipacao().updateDatabase(ParticipacaoJogadorTime(id: vinc.first.id, idJogador: idJogador, idEscola: part.idEscola, valorInscricao: part.valorInscricao));
        } else {
          await ControlParticipacao().insertDatabase(part);
        }
      }
    } catch (e) {
      setState(() {
        _resultado = e.toString();
      });
    }
  }
}
