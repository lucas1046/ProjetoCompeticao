import 'package:flutter/material.dart';
import 'package:projeto_final/control/control_auditoria.dart';
import 'package:projeto_final/telas/menu.dart';
import 'package:projeto_final/widgets/cartao_consulta.dart';

class TelaAuditoria extends StatefulWidget {
  const TelaAuditoria({super.key});

  @override
  State<TelaAuditoria> createState() => _TelaAuditoriaState();
}

class _TelaAuditoriaState extends State<TelaAuditoria> {
  List<Map<String, dynamic>> _logs = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      final l = await ControlAuditoria().listar();
      if (mounted) setState(() { _logs = l; _carregando = false; });
    } catch (_) {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auditoria"),
        backgroundColor: Colors.grey[800],
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
      body: _carregando
          ? Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? Center(child: Text("Nenhum registro de auditoria."))
              : ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (ctx, i) {
                    final l = _logs[i];
                    return CartaoConsulta(
                      "${l['acao']} — ${l['tabela']}",
                      [
                        "Usuário: ${l['nome_usuario'] ?? '-'}",
                        "Registro: ${l['id_registro'] ?? '-'}",
                        "Data: ${l['data_hora']}",
                        if (l['detalhes'] != null) "Detalhes: ${l['detalhes']}",
                      ],
                      icone: Icons.history,
                    );
                  },
                ),
    );
  }
}
