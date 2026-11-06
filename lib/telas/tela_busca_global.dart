import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_competicao.dart';
import 'package:projeto_final/control/control_escola.dart';
import 'package:projeto_final/control/control_jogador.dart';
import 'package:projeto_final/control/control_time.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';
import 'package:projeto_final/widgets/widget_input.dart';
import 'package:projeto_final/widgets/widget_text_custom.dart';

/// Busca global: pesquisa em jogador, time, escola e competição de uma vez.
class TelaBuscaGlobal extends StatefulWidget {
  const TelaBuscaGlobal({super.key});

  @override
  State<TelaBuscaGlobal> createState() => _TelaBuscaGlobalState();
}

class _TelaBuscaGlobalState extends State<TelaBuscaGlobal> {
  final _filtro = TextEditingController();
  List<Map<String, dynamic>> _jogadores = [];
  List<Map<String, dynamic>> _times = [];
  List<Map<String, dynamic>> _escolas = [];
  List<Map<String, dynamic>> _competicoes = [];
  bool _buscando = false;

  @override
  void initState() {
    super.initState();
    _filtro.addListener(_buscar);
  }

  @override
  void dispose() {
    _filtro.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    String f = _filtro.text.trim();
    if (f.isEmpty) {
      setState(() {
        _jogadores = [];
        _times = [];
        _escolas = [];
        _competicoes = [];
        _buscando = false;
      });
      return;
    }
    setState(() => _buscando = true);
    try {
      final cj = ControlJogador();
      final ct = ControlTime();
      final ce = ControlEscola();
      final cc = ControlCompeticao();

      final jog = await cj.queryFindDetalhado(f);
      final tim = await ct.queryFindDetalhado(f);
      final esc = await ce.queryFind(f);
      final com = await cc.queryFind(f);

      if (!mounted) return;
      setState(() {
        _jogadores = jog;
        _times = tim;
        _escolas = esc.map((e) => {'nome': e.nome, 'cidade': e.cidade, 'estado': e.estado}).toList();
        _competicoes = com.map((c) => {'nome': c.nome, 'cidade': c.cidade, 'dataInicio': c.dataInicio, 'dataFim': c.dataFim}).toList();
        _buscando = false;
      });
    } catch (_) {
      if (mounted) setState(() => _buscando = false);
    }
  }

  bool get _temResultados =>
      _jogadores.isNotEmpty || _times.isNotEmpty || _escolas.isNotEmpty || _competicoes.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Busca global"),
        backgroundColor: Colors.teal,
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
        InputTextos("", "Digite para buscar", controller: _filtro),
        SizedBox(height: 16),
        if (_buscando)
          Center(child: CircularProgressIndicator())
        else if (_filtro.text.trim().isEmpty)
          TextosCustom("Digite um termo para buscar em jogador, time, escola e competição.", 14, Colors.grey)
        else if (!_temResultados)
          TextosCustom("Nenhum resultado encontrado.", 18, Colors.red)
        else ...[
          if (_jogadores.isNotEmpty) ...[
            Text("Jogadores", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ..._jogadores.map((j) => CartaoConsulta(
                  j['nome'] ?? "-",
                  [
                    "CPF: ${j['cpf']}",
                    "Responsável: ${j['nomeResponsavel'] ?? '-'}",
                  ],
                  icone: Icons.person,
                )),
            SizedBox(height: 12),
          ],
          if (_times.isNotEmpty) ...[
            Text("Times", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ..._times.map((t) => CartaoConsulta(
                  t['nomeTime'] ?? "-",
                  [
                    "Escola: ${t['nomeEscola']}",
                    "Modalidade: ${t['nomeModalidade']} - ${t['nomeCategoria']}",
                  ],
                  icone: Icons.groups,
                )),
            SizedBox(height: 12),
          ],
          if (_escolas.isNotEmpty) ...[
            Text("Escolas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ..._escolas.map((e) => CartaoConsulta(
                  e['nome'] ?? "-",
                  ["${e['cidade']} - ${e['estado']}"],
                  icone: Icons.school,
                )),
            SizedBox(height: 12),
          ],
          if (_competicoes.isNotEmpty) ...[
            Text("Competições", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ..._competicoes.map((c) => CartaoConsulta(
                  c['nome'] ?? "-",
                  ["${c['cidade']} - ${c['dataInicio']} a ${c['dataFim']}"],
                  icone: Icons.emoji_events,
                )),
          ],
        ],
      ],
    );
  }
}
