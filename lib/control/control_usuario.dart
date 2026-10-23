import 'package:projeto_final/control/banco_dados.dart';
import 'package:projeto_final/model/usuario.dart';
import 'package:projeto_final/util/seguranca.dart';
import 'package:projeto_final/util/validacoes.dart';
import 'package:sqflite/sqflite.dart';

/// Control dos usuarios e autenticacao (RNFR-15.2, RNFR-05.2 e RNFR-16.2).
class ControlUsuario {
  static final ControlUsuario _instancia = ControlUsuario._();

  ControlUsuario._();

  factory ControlUsuario() => _instancia;

  // ---------------------------------------------------------
  // AUTENTICACAO
  // ---------------------------------------------------------

  /// Autentica o usuario e retorna os dados dele.
  /// Lanca RegraNegocioException quando o login ou a senha estao errados.
  Future<Usuario> autenticar(String login, String senha) async {
    if (!Validacoes.textoPreenchido(login) || !Validacoes.textoPreenchido(senha)) {
      throw RegraNegocioException("Informe o login e a senha.");
    }

    Database banco = await BancoDados().db;

    List<Map<String, dynamic>> resultado = await banco.query(
      "usuario",
      where: "login = ?",
      whereArgs: [login.trim()],
      limit: 1,
    );

    if (resultado.isEmpty) {
      throw RegraNegocioException("Login ou senha inválidos.");
    }

    Usuario usuario = Usuario.fromMap(resultado.first);

    if (!Seguranca.conferirSenha(senha, usuario.senhaHash)) {
      throw RegraNegocioException("Login ou senha inválidos.");
    }

    return usuario;
  }

  // ---------------------------------------------------------
  // CONSULTA
  // ---------------------------------------------------------

  Future<List<Usuario>> queryFind() async {
    Database banco = await BancoDados().db;
    List<Map<String, dynamic>> resultados = await banco.query(
      "usuario",
      orderBy: "login",
    );

    return List.generate(resultados.length, (i) {
      return Usuario.fromMap(resultados[i]);
    });
  }

  // ---------------------------------------------------------
  // CADASTRO DE USUARIO
  // ---------------------------------------------------------

  /// Cadastra um novo usuario. Somente um administrador deveria poder
  /// chamar este metodo (RNFR-15.2).
  Future<int> insertDatabase(Usuario usuario) async {
    if (!Validacoes.textoPreenchido(usuario.login)) {
      throw RegraNegocioException("Informe o login do usuário.");
    }

    if (usuario.login.trim().length < 3) {
      throw RegraNegocioException("O login deve ter pelo menos 3 caracteres.");
    }

    if (usuario.perfil != Usuario.administrador &&
        usuario.perfil != Usuario.usuarioComum) {
      throw RegraNegocioException("Perfil inválido. Use ADMIN ou USUARIO.");
    }

    Database banco = await BancoDados().db;

    List<Map<String, dynamic>> existente = await banco.query(
      "usuario",
      where: "login = ?",
      whereArgs: [usuario.login.trim()],
      limit: 1,
    );

    if (existente.isNotEmpty) {
      throw RegraNegocioException("Já existe um usuário com este login.");
    }

    return await BancoDados().inserir("usuario", usuario.toMap());
  }

  /// Cadastra um usuario ja informando a senha em texto, guardando o hash
  Future<int> cadastrarComSenha(
    String login,
    String senha,
    String perfil,
  ) async {
    Usuario usuario = Usuario(
      login: login,
      senhaHash: Seguranca.hashSenha(senha),
      perfil: perfil,
    );

    return await insertDatabase(usuario);
  }
}
