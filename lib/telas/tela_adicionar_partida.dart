import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_competicao.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/control/control_jogador_time.dart';
import 'package:projeto_final/control/control_escalacao.dart';
import 'package:projeto_final/control/control_evento.dart';
import 'package:projeto_final/control/control_partida.dart';
import 'package:projeto_final/control/control_rodada.dart';
import 'package:projeto_final/control/control_time.dart';
import 'package:projeto_final/control/control_tipo_evento.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:projeto_final/model/escalacao.dart';
import 'package:projeto_final/model/evento_partida.dart';
import 'package:projeto_final/model/partida.dart';
import 'package:projeto_final/model/rodada.dart';
import 'package:projeto_final/model/jogador.dart';
import 'package:projeto_final/model/time.dart';
import 'package:projeto_final/util/formatador.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarPartida extends StatefulWidget {
  final Partida? partida;
  const TelaAdicionarPartida({super.key, this.partida});

  @override
  State<TelaAdicionarPartida> createState() => _TelaAdicionarPartidaState();
}

class _TelaAdicionarPartidaState extends State<TelaAdicionarPartida> {
  String? _idRodada;
  String? _idTimeCasa;
  String? _idTimeVisitante;
  bool _wo = false;
  int? _idPartida;
  List<Rodada> _rodadas = [];
  List<Time> _times = [];
  List<TipoEvento> _tiposEvento = [];
  List<Map<String, dynamic>> _eventos = [];
  String _resultado = "";
  List<Jogador> _jogadores = [];
  final Set<int> _selCasa = {};
  final Set<int> _selVis = {};
  Set<int> _rosterCasa = {};
  Set<int> _rosterVis = {};
  final _filtroCasa = TextEditingController();
  final _filtroVis = TextEditingController();
  final _horarioCtrl = TextEditingController();
  String? _idCraque;

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    final rodadas = await ControlRodada().queryFind();
    final times = await ControlTime().queryFind();
    final tipos = await ControlTipoEvento().queryFind();
    final jogadores = await ControlJogador().queryFind();
    setState(() {
      _rodadas = rodadas;
      _times = times;
      _tiposEvento = tipos;
      _jogadores = jogadores;
      if (widget.partida != null) {
        _idPartida = widget.partida!.id;
        _idRodada = widget.partida!.idRodada.toString();
        _idTimeCasa = widget.partida!.idTimeCasa.toString();
        _idTimeVisitante = widget.partida!.idTimeVisitante.toString();
        _wo = widget.partida!.wo;
        if (widget.partida!.horario != null) _horarioCtrl.text = widget.partida!.horario!;
      } else {
        if (rodadas.isNotEmpty) _idRodada = rodadas[0].id.toString();
        if (times.isNotEmpty) {
          _idTimeCasa = times[0].idTime.toString();
          _idTimeVisitante = times.length > 1 ? times[1].idTime.toString() : times[0].idTime.toString();
        }
      }
    });
    if (_idTimeCasa != null) {
      final rows = await ControlJogadorTime().queryByTime(int.parse(_idTimeCasa!));
      setState(() => _rosterCasa = rows.map((r) => r['idJogador'] as int).toSet());
    }
    if (_idTimeVisitante != null) {
      final rows = await ControlJogadorTime().queryByTime(int.parse(_idTimeVisitante!));
      setState(() => _rosterVis = rows.map((r) => r['idJogador'] as int).toSet());
    }
    if (widget.partida != null) {
      final escs = await ControlEscalacao().queryFind();
      setState(() {
        _selCasa.clear();
        _selVis.clear();
        for (final e in escs.where((x) => x.idPartida == widget.partida!.id)) {
          if (e.idTime == int.tryParse(_idTimeCasa ?? "0")) {
            _selCasa.add(e.idJogador);
          } else {
            _selVis.add(e.idJogador);
          }
        }
      });
      await _refreshEventos();
    }
  }

  Future<void> _criarPartida() async {
    try {
      final id = _idPartida;
      final int idPartida;
      if (id != null) {
        final partida = Partida(id: id, idRodada: int.tryParse(_idRodada ?? "0") ?? 0, idTimeCasa: int.tryParse(_idTimeCasa ?? "0") ?? 0, idTimeVisitante: int.tryParse(_idTimeVisitante ?? "0") ?? 0, qtdGolsTimeCasa: 0, qtdGolsTimeVisitante: 0, wo: _wo, horario: _horarioCtrl.text.trim().isEmpty ? null : _horarioCtrl.text.trim());
        await ControlPartida().updateDatabase(partida);
        await ControlEscalacao().deleteByPartida(id);
        idPartida = id;
      } else {
        final partida = Partida(idRodada: int.tryParse(_idRodada ?? "0") ?? 0, idTimeCasa: int.tryParse(_idTimeCasa ?? "0") ?? 0, idTimeVisitante: int.tryParse(_idTimeVisitante ?? "0") ?? 0, qtdGolsTimeCasa: 0, qtdGolsTimeVisitante: 0, wo: _wo, horario: _horarioCtrl.text.trim().isEmpty ? null : _horarioCtrl.text.trim());
        idPartida = await ControlPartida().insertDatabase(partida);
      }
      int criadas = 0;
      for (final jid in _selCasa) {
        try {
          await ControlEscalacao().insertDatabase(Escalacao(idPartida: idPartida, idJogador: jid, idTime: int.tryParse(_idTimeCasa ?? "0")));
          criadas++;
        } catch (e) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro casa: $e")));
        }
      }
      for (final jid in _selVis) {
        try {
          await ControlEscalacao().insertDatabase(Escalacao(idPartida: idPartida, idJogador: jid, idTime: int.tryParse(_idTimeVisitante ?? "0")));
          criadas++;
        } catch (e) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro vis: $e")));
        }
      }
      setState(() {
        _idPartida = idPartida;
        _resultado = "Partida ${id == null ? 'criada' : 'atualizada'} (id: $idPartida). Escalações: $criadas.";
      });
      await _refreshEventos();
    } catch (e) {
      setState(() => _resultado = e.toString());
    }
  }

  Future<void> _refreshEventos() async {
    if (_idPartida == null) return;
    final all = await ControlEvento().queryFindDetalhado();
    final filtered = all.where((e) => e['idPartida'] == _idPartida).toList();
    setState(() => _eventos = filtered);
  }

  int get _golsCasa {
    final timeCasa = _times.firstWhere((t) => t.idTime.toString() == _idTimeCasa, orElse: () => _times.first).nomeTime;
    return _eventos.where((e) {
      final te = (e['tipoEvento'] ?? '').toString().toLowerCase();
      final time = (e['nomeTime'] ?? '').toString();
      return te.contains('gol') && time == timeCasa;
    }).length;
  }

  int get _golsVisitante {
    final timeVis = _times.firstWhere((t) => t.idTime.toString() == _idTimeVisitante, orElse: () => _times.first).nomeTime;
    return _eventos.where((e) {
      final te = (e['tipoEvento'] ?? '').toString().toLowerCase();
      final time = (e['nomeTime'] ?? '').toString();
      return te.contains('gol') && time == timeVis;
    }).length;
  }

  Future<void> _adicionarEvento(String lado) async {
    if (_idPartida == null) return;
    final idTime = lado == 'casa' ? _idTimeCasa : _idTimeVisitante;
    final detalhado = await ControlEscalacao().queryFindDetalhado();
    final escs = detalhado.where((e) => e['idPartida'] == _idPartida && e['nomeTime'] == _times.firstWhere((t) => t.idTime.toString() == idTime, orElse: () => _times.first).nomeTime).toList();
    if (escs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cadastre escalações antes de eventos.")));
      return;
    }
    int? idTipo;
    int? idEsc;
    final minutoCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text("Novo evento — $lado"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: idTipo,
                  decoration: const InputDecoration(labelText: "Tipo de evento"),
                  items: _tiposEvento.map((t) => DropdownMenuItem<int>(value: t.id, child: Text(t.descricao))).toList(),
                  onChanged: (v) => setD(() => idTipo = v),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  initialValue: idEsc,
                  decoration: const InputDecoration(labelText: "Jogador escalado"),
                  items: escs.map((e) => DropdownMenuItem<int>(value: e['id'] as int, child: Text(e['nomeJogador']?.toString() ?? 'Jogador ${e['id']}'))).toList(),
                  onChanged: (v) => setD(() => idEsc = v),
                ),
                SizedBox(height: 8),
                TextField(controller: minutoCtrl, decoration: const InputDecoration(labelText: "Minuto"), keyboardType: TextInputType.number),
                SizedBox(height: 8),
                TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Descrição")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar")),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Salvar")),
          ],
        ),
      ),
    );

    if (ok != true) return;
    try {
      final ev = EventoPartida(
        idTipoEvento: idTipo ?? 0,
        minutoEvento: int.tryParse(minutoCtrl.text) ?? 0,
        descricao: descCtrl.text,
        idEscalacao: idEsc ?? 0,
      );
      await ControlEvento().insertDatabase(ev);
      await _refreshEventos();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Evento registrado.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _excluirEvento(int id) async {
    await ControlEvento().deleteDatabase(id);
    await _refreshEventos();
  }

  Future<void> _novaRodada() async {
    final numeroCtrl = TextEditingController();
    final dataCtrl = TextEditingController();
    List<Competicao> comps = await ControlCompeticao().queryFind();
    int? idComp = comps.isNotEmpty ? comps[0].id : null;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text("Nova rodada"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: idComp,
                decoration: InputDecoration(labelText: "Competição"),
                items: comps.map((c) => DropdownMenuItem<int>(value: c.id, child: Text(c.nome))).toList(),
                onChanged: (v) => setStateDialog(() => idComp = v),
              ),
              SizedBox(height: 8),
              TextField(controller: numeroCtrl, decoration: InputDecoration(labelText: "Número"), keyboardType: TextInputType.number),
              SizedBox(height: 8),
              TextField(controller: dataCtrl, decoration: InputDecoration(labelText: "Data (dd/MM/yyyy)")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar")),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Salvar")),
          ],
        ),
      ),
    );

    if (ok != true) return;
    try {
      final rodada = Rodada(numero: int.tryParse(numeroCtrl.text) ?? 0, data: Formatador.dataIso(dataCtrl.text), idCompeticao: idComp ?? 0);
      await ControlRodada().insertDatabase(rodada);
      await _carregarListas();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rodada criada.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar partida"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(icon: Icon(Icons.home), onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Menu()), (_) => false)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (_idPartida == null) ...[
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _idRodada,
                    decoration: const InputDecoration(labelText: "Rodada", border: OutlineInputBorder()),
                    items: _rodadas.map((r) => DropdownMenuItem<String>(value: r.id.toString(), child: Text("Rodada ${r.numero}"))).toList(),
                    onChanged: (v) => setState(() => _idRodada = v),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(tooltip: "Nova rodada", icon: Icon(Icons.add_circle, color: Colors.green), onPressed: _novaRodada),
              ],
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _idTimeCasa,
              decoration: const InputDecoration(labelText: "Time da casa", border: OutlineInputBorder()),
              items: _times.map((t) => DropdownMenuItem<String>(value: t.idTime.toString(), child: Text(t.nomeTime))).toList(),
              onChanged: (v) async {
                setState(() => _idTimeCasa = v);
                if (v != null) {
                  final rows = await ControlJogadorTime().queryByTime(int.parse(v));
                  setState(() => _rosterCasa = rows.map((r) => r['idJogador'] as int).toSet());
                }
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _idTimeVisitante,
              decoration: const InputDecoration(labelText: "Time visitante", border: OutlineInputBorder()),
              items: _times.map((t) => DropdownMenuItem<String>(value: t.idTime.toString(), child: Text(t.nomeTime))).toList(),
              onChanged: (v) async {
                setState(() => _idTimeVisitante = v);
                if (v != null) {
                  final rows = await ControlJogadorTime().queryByTime(int.parse(v));
                  setState(() => _rosterVis = rows.map((r) => r['idJogador'] as int).toSet());
                }
              },
            ),
            TextField(controller: _horarioCtrl, decoration: InputDecoration(labelText: "Horário (ex: 09:00)", border: OutlineInputBorder())),
            SizedBox(height: 12),
            CheckboxListTile(title: Text("WO (W.O.)"), value: _wo, onChanged: (v) => setState(() => _wo = v ?? false)),
            SizedBox(height: 8),
            Text("Jogadores da casa:", style: TextStyle(fontWeight: FontWeight.bold)),
            ..._jogadores.where((j) => _rosterCasa.contains(j.id) && (_filtroCasa.text.isEmpty || j.nome.toLowerCase().contains(_filtroCasa.text.toLowerCase()))).map((j) => CheckboxListTile(
              title: Text(j.nome),
              value: _selCasa.contains(j.id),
              onChanged: (v) => setState(() { if (v == true) {
                _selCasa.add(j.id!);
              } else {
                _selCasa.remove(j.id);
              } }),
            )),
            Text("Jogadores do visitante:", style: TextStyle(fontWeight: FontWeight.bold)),
            ..._jogadores.where((j) => _rosterVis.contains(j.id) && (_filtroVis.text.isEmpty || j.nome.toLowerCase().contains(_filtroVis.text.toLowerCase()))).map((j) => CheckboxListTile(
              title: Text(j.nome),
              value: _selVis.contains(j.id),
              onChanged: (v) => setState(() { if (v == true) {
                _selVis.add(j.id!);
              } else {
                _selVis.remove(j.id);
              } }),
            )),
            SizedBox(height: 8),
            Buttons("Criar partida", onPressed: _criarPartida),
            TextosCustom(_resultado, 16, Colors.red),
          ] else ...[
            TextosCustom("Partida #$_idPartida", 18, Colors.black),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [Text("Casa", style: TextStyle(fontWeight: FontWeight.bold)), Text("$_golsCasa", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))]),
                Text("x", style: TextStyle(fontSize: 24)),
                Column(children: [Text("Visitante", style: TextStyle(fontWeight: FontWeight.bold)), Text("$_golsVisitante", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))]),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Buttons("+ Evento (casa)", onPressed: () => _adicionarEvento('casa'))),
                SizedBox(width: 8),
                Expanded(child: Buttons("+ Evento (visitante)", onPressed: () => _adicionarEvento('visitante'))),
              ],
            ),
            SizedBox(height: 12),
            TextosCustom("Eventos", 16, Colors.black),
            ..._eventos.map((e) => Card(
                  child: ListTile(
                    title: Text("${e['tipoEvento']} — ${e['nomeJogador']} (${e['nomeTime']})"),
                    subtitle: Text("Min ${e['minuto']}${(e['descricao'] ?? '').toString().isEmpty ? '' : ' — ${e['descricao']}'}"),
                    trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _excluirEvento(e['id'] as int)),
                  ),
                )),
            if (_eventos.isEmpty) TextosCustom("Nenhum evento registrado.", 14, Colors.grey),
            SizedBox(height: 12),
            TextosCustom(_resultado, 14, Colors.green),
          ],
        ],
      ),
    );
  }
}
