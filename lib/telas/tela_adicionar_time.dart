import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_categoria.dart';
import 'package:projeto_final/control/control_escola.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/control/control_jogador_time.dart';
import 'package:projeto_final/control/control_posicao.dart';
import 'package:projeto_final/control/control_time.dart';
import 'package:projeto_final/model/categoria.dart';
import 'package:projeto_final/model/escola.dart';
import 'package:projeto_final/control/control_jogador_time.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/model/jogador_time.dart';
import 'package:projeto_final/model/posicao.dart';
import 'package:projeto_final/model/time.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarTime extends StatefulWidget {
  final Time? time;
  const TelaAdicionarTime({super.key, this.time});

  @override
  State<TelaAdicionarTime> createState() => _TelaAdicionarTimeState();
}

class _TelaAdicionarTimeState extends State<TelaAdicionarTime> {
  int? _idTimeEdicao;
  String? _idEscola;
  String? _idCategoria;
  List<Escola> _escolas = [];
  List<Categoria> _categorias = [];
  List<Jogador> _jogadores = [];
  List<Posicao> _posicoes = [];
  final Set<int> _selJogadores = {};
  final Map<int, int?> _posicaoPorJogador = {};
  final Map<int, int?> _camisaPorJogador = {};
  final _filtro = TextEditingController();
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    final escolas = await ControlEscola().queryFind();
    final categorias = await ControlCategoria().queryFind();
    final posicoes = await ControlPosicao().queryFind();
    final idEscola = widget.time != null ? widget.time!.idEscola : (escolas.isNotEmpty ? escolas[0].id : null);
    final jogadores = idEscola != null ? await ControlJogador().queryByEscola(idEscola) : await ControlJogador().queryFind();
    setState(() {
      _escolas = escolas;
      _categorias = categorias;
      _jogadores = jogadores;
      _posicoes = posicoes;
      if (widget.time != null) {
        _idTimeEdicao = widget.time!.idTime;
        _idEscola = widget.time!.idEscola.toString();
        _idCategoria = widget.time!.idCategoria.toString();
      } else {
        if (escolas.isNotEmpty) _idEscola = escolas[0].id.toString();
        if (categorias.isNotEmpty) _idCategoria = categorias[0].id.toString();
      }
    });
    if (widget.time != null) {
      final rows = await ControlJogadorTime().queryByTime(widget.time!.idTime!);
      setState(() {
        for (final r in rows) {
          final jid = r['idJogador'] as int;
          _selJogadores.add(jid);
          _posicaoPorJogador[jid] = r['idPosicao'] as int?;
          _camisaPorJogador[jid] = r['numero_camisa'] as int?;
        }
      });
    }
  }

  Future<void> _registrar() async {
    try {
      final escola = _escolas.firstWhere((e) => e.id.toString() == _idEscola);
      final categoria = _categorias.firstWhere((c) => c.id.toString() == _idCategoria);
      String base = "${escola.nome} ${categoria.nome}";
      final existentes = await ControlTime().queryFind();
      int count = existentes.where((t) => t.nomeTime.startsWith(base)).length;
      String nome = _idTimeEdicao != null ? widget.time!.nomeTime : (count == 0 ? base : "$base (${count + 1})");

      Time time = Time(
        idEscola: int.parse(_idEscola!),
        idCategoria: int.parse(_idCategoria!),
        nomeTime: nome,
      );
      final int idTime;
      if (_idTimeEdicao != null) {
        time = Time(idTime: _idTimeEdicao, idEscola: time.idEscola, idCategoria: time.idCategoria, nomeTime: time.nomeTime);
        await ControlTime().updateDatabase(time);
        idTime = _idTimeEdicao!;
      } else {
        idTime = await ControlTime().insertDatabase(time);
      }

      if (_idTimeEdicao != null) {
        await ControlJogadorTime().deleteByTime(idTime);
      }

      int criadas = 0;
      for (final jid in _selJogadores) {
        try {
          await ControlJogadorTime().insertDatabase(JogadorTime(
            idTime: idTime,
            idJogador: jid,
            idPosicao: _posicaoPorJogador[jid],
            numeroCamisa: _camisaPorJogador[jid],
          ));
          criadas++;
        } catch (e) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: $e")));
        }
      }
      setState(() => _resultado = "Time criado: $nome. Jogadores: $criadas.");
      await _carregarListas();
    } catch (e) {
      setState(() => _resultado = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar time"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(icon: Icon(Icons.home), onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Menu()), (_) => false)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _dropdown("Escola", _idEscola, _escolas.map((e) => _Item(e.id.toString(), e.nome)).toList(), (v) async {
            setState(() => _idEscola = v);
            if (v != null) {
              final js = await ControlJogador().queryByEscola(int.parse(v));
              setState(() => _jogadores = js);
            }
          }),
          SizedBox(height: 12),
          _dropdown("Categoria", _idCategoria, _categorias.map((c) => _Item(c.id.toString(), c.nome)).toList(), (v) => setState(() => _idCategoria = v)),
          SizedBox(height: 12),
          Text("Jogadores:", style: TextStyle(fontWeight: FontWeight.bold)),
          ..._jogadores
              .where((j) => _filtro.text.isEmpty || j.nome.toLowerCase().contains(_filtro.text.toLowerCase()))
              .map((j) => CheckboxListTile(
                    title: Text(j.nome),
                    value: _selJogadores.contains(j.id),
                    onChanged: (v) => setState(() {
                      if (v == true) _selJogadores.add(j.id!);
                      else _selJogadores.remove(j.id);
                    }),
                    subtitle: _selJogadores.contains(j.id)
                        ? Row(
                            children: [
                              DropdownButton<int?>(
                                value: _posicaoPorJogador[j.id],
                                hint: Text("Posição"),
                                items: _posicoes.map((p) => DropdownMenuItem(value: p.id, child: Text(p.nome))).toList(),
                                onChanged: (v) => setState(() => _posicaoPorJogador[j.id!] = v),
                              ),
                              SizedBox(width: 8),
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  decoration: InputDecoration(labelText: "Camisa"),
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(text: _camisaPorJogador[j.id]?.toString() ?? ""),
                                  onChanged: (v) => _camisaPorJogador[j.id!] = int.tryParse(v),
                                ),
                              ),
                            ],
                          )
                        : null,
                  )),
          SizedBox(height: 16),
          Buttons("Registrar", onPressed: _registrar),
          TextosCustom(_resultado, 18, Colors.red),
        ],
      ),
    );
  }

  Widget _dropdown(String rotulo, String? valor, List<_Item> itens, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: valor,
      decoration: InputDecoration(labelText: rotulo, border: OutlineInputBorder()),
      items: itens.map((i) => DropdownMenuItem<String>(value: i.id, child: Text(i.nome))).toList(),
      onChanged: onChanged,
    );
  }
}

class _Item {
  final String id;
  final String nome;
  _Item(this.id, this.nome);
}