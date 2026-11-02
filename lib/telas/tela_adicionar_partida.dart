import 'package:flutter/material.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/control/control_competicao.dart';
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
import 'package:projeto_final/model/time.dart';
import 'package:projeto_final/model/tipo_evento.dart';
import 'package:projeto_final/widgets/widget_button.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

class TelaAdicionarPartida extends StatefulWidget {
  const TelaAdicionarPartida({super.key});

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

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    final rodadas = await ControlRodada().queryFind();
    final times = await ControlTime().queryFind();
    final tipos = await ControlTipoEvento().queryFind();
    setState(() {
      _rodadas = rodadas;
      _times = times;
      _tiposEvento = tipos;
      if (rodadas.isNotEmpty) _idRodada = rodadas[0].id.toString();
      if (times.isNotEmpty) {
        _idTimeCasa = times[0].idTime.toString();
        _idTimeVisitante = times.length > 1 ? times[1].idTime.toString() : times[0].idTime.toString();
      }
    });
  }

  Future<void> _criarPartida() async {
    final partida = Partida(
      idRodada: int.tryParse(_idRodada ?? "0") ?? 0,
      idTimeCasa: int.tryParse(_idTimeCasa ?? "0") ?? 0,
      idTimeVisitante: int.tryParse(_idTimeVisitante ?? "0") ?? 0,
      qtdGolsTimeCasa: 0,
      qtdGolsTimeVisitante: 0,
      wo: _wo,
    );
    try {
      final id = await ControlPartida().insertDatabase(partida);
      // copia o roster (escalacoes do time) para esta partida
      final timeCasaId = int.tryParse(_idTimeCasa ?? "0") ?? 0;
      final timeVisId = int.tryParse(_idTimeVisitante ?? "0") ?? 0;
      final roster = (await ControlEscalacao().queryFind()).where((e) => e.idPartida == 0).toList();
      for (final r in roster) {
        if (r.idTime == timeCasaId || r.idTime == timeVisId) {
          try {
            await ControlEscalacao().insertDatabase(Escalacao(
              idPartida: id,
              idTime: r.idTime,
              titular: r.titular,
              numeroCamisa: r.numeroCamisa,
              idPosicao: r.idPosicao,
              idParticipacao: r.idParticipacao,
            ));
          } catch (_) {}
        }
      }
      setState(() {
        _idPartida = id;
        _resultado = "Partida criada (id: $id). Eventos podem ser registrados.";
      });
      await _refreshEventos();
    } catch (e) {
      setState(() => _resultado = e.toString());
    }
  }

  Future<void> _refreshEventos() async {
    if (_idPartida == null) return;
    final all = await ControlEvento().queryFindDetalhado();
    final timeCasa = _times.firstWhere((t) => t.idTime.toString() == _idTimeCasa, orElse: () => _times.first).nomeTime;
    final timeVis = _times.firstWhere((t) => t.idTime.toString() == _idTimeVisitante, orElse: () => _times.first).nomeTime;
    final filtered = all.where((e) {
      final t = (e['nomeTime'] ?? '').toString();
      return t == timeCasa || t == timeVis;
    }).toList();
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
    final escs = (await ControlEscalacao().queryFind()).where((e) => e.idPartida == _idPartida).toList();
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
                  value: idTipo,
                  decoration: const InputDecoration(labelText: "Tipo de evento"),
                  items: _tiposEvento.map((t) => DropdownMenuItem<int>(value: t.id, child: Text(t.descricao))).toList(),
                  onChanged: (v) => setD(() => idTipo = v),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: idEsc,
                  decoration: const InputDecoration(labelText: "Jogador escalado"),
                  items: escs.map((e) => DropdownMenuItem<int>(value: e.id, child: Text("Esc. ${e.id}"))).toList(),
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
                value: idComp,
                decoration: InputDecoration(labelText: "Competição"),
                items: comps.map((c) => DropdownMenuItem<int>(value: c.id, child: Text(c.nome))).toList(),
                onChanged: (v) => setStateDialog(() => idComp = v),
              ),
              SizedBox(height: 8),
              TextField(controller: numeroCtrl, decoration: InputDecoration(labelText: "Número"), keyboardType: TextInputType.number),
              SizedBox(height: 8),
              TextField(controller: dataCtrl, decoration: InputDecoration(labelText: "Data (AAAA-MM-DD)")),
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
      final rodada = Rodada(numero: int.tryParse(numeroCtrl.text) ?? 0, data: dataCtrl.text, idCompeticao: idComp ?? 0);
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
                    value: _idRodada,
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
              value: _idTimeCasa,
              decoration: const InputDecoration(labelText: "Time da casa", border: OutlineInputBorder()),
              items: _times.map((t) => DropdownMenuItem<String>(value: t.idTime.toString(), child: Text(t.nomeTime))).toList(),
              onChanged: (v) => setState(() => _idTimeCasa = v),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _idTimeVisitante,
              decoration: const InputDecoration(labelText: "Time visitante", border: OutlineInputBorder()),
              items: _times.map((t) => DropdownMenuItem<String>(value: t.idTime.toString(), child: Text(t.nomeTime))).toList(),
              onChanged: (v) => setState(() => _idTimeVisitante = v),
            ),
            CheckboxListTile(title: Text("WO (W.O.)"), value: _wo, onChanged: (v) => setState(() => _wo = v ?? false)),
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
