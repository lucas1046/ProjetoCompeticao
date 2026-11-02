import 'package:path/path.dart';
import 'package:projeto_final/model/usuario.dart';
import 'package:projeto_final/util/seguranca.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

/// Helper central do banco de dados SQLite.
/// Abre/cria a base e garante que todas as tabelas existam.
class BancoDados {
  static final BancoDados _instancia = BancoDados._();

  BancoDados._();

  factory BancoDados() => _instancia;

  static const String _nomeBanco = "bd_competicao.db";
  static const int _versao = 9;

  Database? _db;

  // Retorna o banco, iniciando caso ainda não esteja aberto
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _iniciarBanco();
    return _db!;
  }

  // Pega o caminho da base e abre/cria o arquivo
  Future<Database> _iniciarBanco() async {
    String caminho = await getDatabasesPath();
    String caminhoFinal = join(caminho, _nomeBanco);
    return await openDatabase(
      caminhoFinal,
      version: _versao,
      onCreate: (db, version) async {
        await _criarTabelas(db);
        await _garantirAdmin(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Migracao v1 -> v2: adiciona as constraints de unicidade
        // (RNFR-01.2, 04.2, 06.2, 08.2, 10.1) como indices UNIQUE.
        // As tabelas sao preservadas para nao apagar os dados ja cadastrados.
        if (oldVersion < 2) {
          await db.execute(
            "CREATE UNIQUE INDEX IF NOT EXISTS idx_competicao_nome "
            "ON competicao(nome)",
          );
          await db.execute(
            "CREATE UNIQUE INDEX IF NOT EXISTS idx_categoria_nome "
            "ON categoria(nome)",
          );
          await db.execute(
            "CREATE UNIQUE INDEX IF NOT EXISTS idx_time_nome_escola_modalidade "
            "ON time(nome_time, id_escola, id_modalidade, id_categoria)",
          );
          await db.execute(
            "CREATE UNIQUE INDEX IF NOT EXISTS idx_participacao_jogador_time "
            "ON participacao_jogador_time(id_jogador, id_time)",
          );
          await db.execute(
            "CREATE UNIQUE INDEX IF NOT EXISTS idx_rodada_numero_competicao "
            "ON rodada(numero, id_competicao)",
          );
          await db.execute(
            "CREATE UNIQUE INDEX IF NOT EXISTS idx_escalacao_partida_jogador "
            "ON escalacao(id_partida, id_participacao_jogador_time)",
          );
        }

        // Migracao v2 -> v3: unicidade do vinculo tecnico/time (RNFR-07.1)
        // e a tabela de usuarios para o controle de acesso (RNFR-15.2)
        if (oldVersion < 3) {
          await db.execute(
            "CREATE UNIQUE INDEX IF NOT EXISTS idx_tecnico_time_unico "
            "ON tecnico_time(id_tecnico, id_time)",
          );
          await db.execute(_sqlTabelaUsuario);
          await db.execute(_sqlTabelaLog);
          await _garantirAdmin(db);
        }

        // Migracao v3 -> v4: tabela de auditoria (RNFR extra)
        if (oldVersion < 4) {
          await db.execute(_sqlTabelaLog);
        }

        // Migracao v4 -> v5: vinculo de foto ao jogador
        if (oldVersion < 5) {
          await db.execute(
            "ALTER TABLE jogador ADD COLUMN id_foto INTEGER REFERENCES foto_figurinha(id)",
          );
        }

        // Migracao v5 -> v6: vinculo da escalação ao time (roster reutilizavel)
        if (oldVersion < 6) {
          await db.execute(
            "ALTER TABLE escalacao ADD COLUMN id_time INTEGER REFERENCES time(id_time)",
          );
        }

        // Migracao v6 -> v7: posição e camisa no jogador (Fase A)
        if (oldVersion < 7) {
          await db.execute(
            "ALTER TABLE jogador ADD COLUMN id_posicao INTEGER REFERENCES posicao(id)",
          );
          await db.execute(
            "ALTER TABLE jogador ADD COLUMN numero_camisa INTEGER",
          );
        }

        // Migracao v7 -> v8: inscrição simplificada (escola de origem, sem time)
        if (oldVersion < 8) {
          await db.execute(
            "ALTER TABLE participacao_jogador_time ADD COLUMN id_escola INTEGER REFERENCES escola(id)",
          );
        }

        // Migracao v8 -> v9: escalação por jogador (Fase C)
        if (oldVersion < 9) {
          await db.execute(
            "ALTER TABLE escalacao ADD COLUMN id_jogador INTEGER REFERENCES jogador(id)",
          );
        }
      },
    );
  }

  // Insere um registro ja traduzindo a violacao de unicidade (constraint
  // UNIQUE do SQLite) para RegraNegocioException, evitando que a interface
  // mostre o erro tecnico cru. As RNFRs que exigem unicidade tem uma
  // checagem previa especifica; este helper garante a mensagem amigavel
  // mesmo se dois cadastros concorrerem.
  Future<int> inserir(String tabela, Map<String, dynamic> valores) async {
    Database banco = await db;

    try {
      return await banco.insert(tabela, valores);
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw RegraNegocioException(
          'Registro duplicado: já existe um cadastro com estes dados.',
        );
      }
      rethrow;
    }
  }

  // Cria todas as tabelas com as constraints de integridade (RNFRs)
  Future<void> _criarTabelas(Database db) async {
    // RNFR-03.2 — imagem armazenada como caminho; tamanho validado na UI
    await db.execute(
      "CREATE TABLE IF NOT EXISTS foto_figurinha("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "caminho_arquivo VARCHAR(255) NOT NULL, "
      "data_upload DATE NOT NULL)",
    );

    // RNFR-16.1 — CPF unico
    await db.execute(
      "CREATE TABLE IF NOT EXISTS responsavel("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "nome VARCHAR(150) NOT NULL, "
      "cpf VARCHAR(14) NOT NULL UNIQUE, "
      "telefone VARCHAR(20), "
      "email VARCHAR(100), "
      "parentesco VARCHAR(50))",
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS tipo_evento("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "descricao VARCHAR(100) NOT NULL)",
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS modalidade("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "nome VARCHAR(100) NOT NULL)",
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS categoria("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "nome VARCHAR(50) NOT NULL UNIQUE, "
      "idade_min INTEGER NOT NULL, "
      "idade_max INTEGER NOT NULL)",
    );

    // RNFR-01.2 — nome da competição único
    await db.execute(
      "CREATE TABLE IF NOT EXISTS competicao("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "nome VARCHAR(150) NOT NULL UNIQUE, "
      "cidade VARCHAR(100) NOT NULL, "
      "data_inicio DATE NOT NULL, "
      "data_fim DATE NOT NULL)",
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS tecnico("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "nome VARCHAR(150) NOT NULL, "
      "telefone VARCHAR(20), "
      "email VARCHAR(100))",
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS escola("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "nome VARCHAR(150) NOT NULL, "
      "cidade VARCHAR(100) NOT NULL, "
      "estado VARCHAR(50) NOT NULL, "
      "telefone VARCHAR(20), "
      "id_foto INTEGER REFERENCES foto_figurinha(id) ON DELETE SET NULL)",
    );

    // RNFR-05.1 — CPF unico
    await db.execute(
      "CREATE TABLE IF NOT EXISTS jogador("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "cpf VARCHAR(14) UNIQUE, "
      "nome VARCHAR(150) NOT NULL, "
      "data_nascimento DATE NOT NULL, "
      "id_responsavel INTEGER REFERENCES responsavel(id) ON DELETE SET NULL, "
      "id_foto INTEGER REFERENCES foto_figurinha(id), "
      "id_posicao INTEGER REFERENCES posicao(id), "
      "numero_camisa INTEGER)",
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS documento("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "id_jogador INTEGER NOT NULL REFERENCES jogador(id) ON DELETE CASCADE, "
      "tipo_documento VARCHAR(50) NOT NULL, "
      "caminho_arquivo VARCHAR(255) NOT NULL)",
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS posicao("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "nome VARCHAR(50) NOT NULL, "
      "id_modalidade INTEGER NOT NULL REFERENCES modalidade(id) ON DELETE CASCADE)",
    );

    // RNFR-08.2 — número da rodada único por competição
    await db.execute(
      "CREATE TABLE IF NOT EXISTS rodada("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "numero INTEGER NOT NULL, "
      "data DATE NOT NULL, "
      "id_competicao INTEGER NOT NULL REFERENCES competicao(id) ON DELETE CASCADE, "
      "UNIQUE(numero, id_competicao))",
    );

    // RNFR-04.2 — nome do time único por escola/modalidade/categoria
    await db.execute(
      "CREATE TABLE IF NOT EXISTS time("
      "id_time INTEGER PRIMARY KEY AUTOINCREMENT, "
      "id_modalidade INTEGER NOT NULL REFERENCES modalidade(id), "
      "id_escola INTEGER NOT NULL REFERENCES escola(id) ON DELETE CASCADE, "
      "id_categoria INTEGER NOT NULL REFERENCES categoria(id), "
      "nome_time VARCHAR(100) NOT NULL, "
      "UNIQUE(nome_time, id_escola, id_modalidade, id_categoria))",
    );

    // RNFR-07.1 — cada vinculo tecnico/time e unico (um tecnico pode ter varios)
    await db.execute(
      "CREATE TABLE IF NOT EXISTS tecnico_time("
      "id_tecnico_time INTEGER PRIMARY KEY AUTOINCREMENT, "
      "id_tecnico INTEGER NOT NULL REFERENCES tecnico(id) ON DELETE CASCADE, "
      "id_time INTEGER NOT NULL REFERENCES time(id_time) ON DELETE CASCADE, "
      "id_foto INTEGER REFERENCES foto_figurinha(id) ON DELETE SET NULL, "
      "UNIQUE(id_tecnico, id_time))",
    );

    // RNFR-06.2 — jogador não se inscreve duas vezes no mesmo time
    await db.execute(
      "CREATE TABLE IF NOT EXISTS participacao_jogador_time("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "id_jogador INTEGER NOT NULL REFERENCES jogador(id) ON DELETE CASCADE, "
      "id_time INTEGER REFERENCES time(id_time) ON DELETE CASCADE, "
      "id_escola INTEGER REFERENCES escola(id) ON DELETE SET NULL, "
      "valor_inscricao REAL, "
      "id_foto INTEGER REFERENCES foto_figurinha(id) ON DELETE SET NULL, "
      "UNIQUE(id_jogador, id_escola))",
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS pagamento_inscricao("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "id_participacao_jogador_time INTEGER NOT NULL "
      "REFERENCES participacao_jogador_time(id) ON DELETE CASCADE, "
      "valor_pago REAL NOT NULL, "
      "data_pagamento DATE NOT NULL, "
      "forma_pagamento VARCHAR(50) NOT NULL, "
      "observacoes VARCHAR(255))",
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS partida("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "id_rodada INTEGER NOT NULL REFERENCES rodada(id) ON DELETE CASCADE, "
      "id_time_casa INTEGER NOT NULL REFERENCES time(id_time), "
      "id_time_visitante INTEGER NOT NULL REFERENCES time(id_time), "
      "qtd_gols_time_casa INTEGER DEFAULT 0, "
      "qtd_gols_time_visitante INTEGER DEFAULT 0, "
      "wo INTEGER DEFAULT 0, "
      "id_time_wo INTEGER REFERENCES time(id_time), "
      "id_escalacao_craque INTEGER)",
    );

    // RNFR-10.1 — um jogador escalado uma única vez por partida
    await db.execute(
      "CREATE TABLE IF NOT EXISTS escalacao("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "id_partida INTEGER NOT NULL REFERENCES partida(id) ON DELETE CASCADE, "
      "id_jogador INTEGER REFERENCES jogador(id), "
      "id_time INTEGER REFERENCES time(id_time), "
      "titular VARCHAR(10) NOT NULL, "
      "numero_camisa INTEGER NOT NULL, "
      "id_posicao INTEGER NOT NULL REFERENCES posicao(id), "
      "id_participacao_jogador_time INTEGER NOT NULL "
      "REFERENCES participacao_jogador_time(id), "
      "UNIQUE(id_partida, id_participacao_jogador_time))",
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS evento_partida("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "id_tipo_evento INTEGER NOT NULL REFERENCES tipo_evento(id), "
      "minuto_evento INTEGER NOT NULL, "
      "descricao VARCHAR(255), "
      "id_escalacao INTEGER NOT NULL REFERENCES escalacao(id) ON DELETE CASCADE)",
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS suspensao("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "id_evento INTEGER NOT NULL REFERENCES evento_partida(id) ON DELETE CASCADE, "
      "motivo VARCHAR(255) NOT NULL, "
      "qtd_jogos_suspensao INTEGER DEFAULT 1, "
      "cumprida INTEGER DEFAULT 0)",
    );

    // RNFR-15.2 — usuarios e perfis para o controle de acesso
    await db.execute(_sqlTabelaUsuario);
    await db.execute(_sqlTabelaLog);
  }

  // RNFR-15.2 — tabela de usuarios (login, senha com hash e perfil)
  static const String _sqlTabelaUsuario =
      "CREATE TABLE IF NOT EXISTS usuario("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "login VARCHAR(50) NOT NULL UNIQUE, "
      "senha_hash VARCHAR(255) NOT NULL, "
      "perfil VARCHAR(20) NOT NULL DEFAULT 'USUARIO')";

  static const String _sqlTabelaLog =
      "CREATE TABLE IF NOT EXISTS log_auditoria("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "id_usuario INTEGER, "
      "nome_usuario VARCHAR(50), "
      "acao VARCHAR(20) NOT NULL, "
      "tabela VARCHAR(50) NOT NULL, "
      "id_registro INTEGER, "
      "data_hora DATETIME NOT NULL, "
      "detalhes VARCHAR(500))";

  // RNFR-15.2 — garante um administrador inicial para que o primeiro acesso
  // ao sistema nao fique bloqueado. Login "admin" e senha "admin123".
  Future<void> _garantirAdmin(Database db) async {
    List<Map<String, dynamic>> resultado = await db.rawQuery(
      "SELECT COUNT(*) AS total FROM usuario",
    );
    int total = resultado.first['total'] as int? ?? 0;

    if (total == 0) {
      await db.insert("usuario", {
        "login": "admin",
        "senha_hash": Seguranca.hashSenha("admin123"),
        "perfil": Usuario.administrador,
      });
    }
  }
}
