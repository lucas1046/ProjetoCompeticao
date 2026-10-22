import 'package:path/path.dart';
import 'package:projeto_final/model/competicao.dart';
import 'package:sqflite/sqflite.dart';

class ControlCompeticao {
  static final ControlCompeticao _instancia = ControlCompeticao._();

  ControlCompeticao._();

  factory ControlCompeticao() => _instancia;

  Database? _db;

  // ---------------------------------------------------------
  // BANCO DE DADOS
  // ---------------------------------------------------------

  // Inicia o banco, caso não esteja iniciado chama o método para abrir ou criar
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _iniciarBanco();
    return _db!;
  }

  // Pega o caminho do banco e cria/abrir a base de dados
  Future<Database> _iniciarBanco() async {
    String caminho = await getDatabasesPath();
    String caminhoFinal = join(caminho, "bd_competicao.db");
    return await openDatabase(
      caminhoFinal,
      version: 1,
      onCreate: _criarTabelas,
    );
  }

  // Cria as tabelas caso não existam
  _criarTabelas(Database db, int version) async {
    String sql = "CREATE TABLE competicao("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "nome VARCHAR(150) NOT NULL, "
        "cidade VARCHAR(100) NOT NULL, "
        "data_inicio DATE NOT NULL, "
        "data_fim DATE NOT NULL"
        ")";
    await db.execute(sql);
  }

  // ---------------------------------------------------------
  // CRUD - COMPETIÇÃO
  // ---------------------------------------------------------

  // Realiza o insert dos dados passando o objeto competicao
  Future<int> insertDatabase(Competicao competicao) async {
    Database banco = await db;
    return await banco.insert("competicao", competicao.toMap());
  }

  // Realiza a consulta dos dados, aceita um filtro por nome
  Future<List<Competicao>> queryFind([String? nome]) async {
    Database banco = await db;
    List<Map<String, dynamic>> resultados;

    if (nome != null && nome.isNotEmpty) {
      resultados = await banco.query(
        "competicao",
        where: "nome LIKE ?",
        whereArgs: ["%$nome%"],
      );
    } else {
      resultados = await banco.query("competicao");
    }

    return List.generate(resultados.length, (i) {
      return Competicao.fromMap(resultados[i]);
    });
  }

  // ---------------------------------------------------------
  // MÉTODOS DO PADRÃO ANTIGO (mantidos para compatibilidade)
  // ---------------------------------------------------------

  Future<int> salvarCompeticao(Competicao competicao) async {
    return await insertDatabase(competicao);
  }

  Future<List<Competicao>> consultarCompeticoes() async {
    return await queryFind();
  }
}
