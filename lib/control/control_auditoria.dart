import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/control/control_sessao.dart';
import 'package:sqflite/sqflite.dart';

/// Registra acoes de auditoria (quem alterou o que e quando).
class ControlAuditoria {
  static final ControlAuditoria _instancia = ControlAuditoria._();
  ControlAuditoria._();
  factory ControlAuditoria() => _instancia;

  Future<void> registrar({
    required String acao, // INSERT / UPDATE / DELETE
    required String tabela,
    int? idRegistro,
    String? detalhes,
  }) async {
    try {
      Database banco = await BancoDados().db;
      final u = ControlSessao().usuario;
      await banco.insert('log_auditoria', {
        'id_usuario': u?.id,
        'nome_usuario': u?.login ?? 'anonimo',
        'acao': acao,
        'tabela': tabela,
        'id_registro': idRegistro,
        'data_hora': DateTime.now().toIso8601String(),
        'detalhes': detalhes,
      });
    } catch (_) {
      // auditoria nunca deve quebrar a operacao principal
    }
  }

  Future<List<Map<String, dynamic>>> listar() async {
    Database banco = await BancoDados().db;
    return await banco.query('log_auditoria', orderBy: 'id DESC', limit: 200);
  }
}
