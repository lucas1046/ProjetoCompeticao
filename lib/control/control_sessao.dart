import 'package:projeto_final/model/usuario.dart';

/// Guarda o usuario autenticado durante a execucao do app (RNFR-15.2).
/// Fica em memoria: ao fechar o app e preciso autenticar de novo.
class ControlSessao {
  static final ControlSessao _instancia = ControlSessao._();

  ControlSessao._();

  factory ControlSessao() => _instancia;

  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  bool get logado => _usuario != null;

  /// RNFR-15.2 — relatorios financeiros e dados restritos exigem ADMIN
  bool get isAdministrador => _usuario?.isAdministrador ?? false;

  void entrar(Usuario usuario) {
    _usuario = usuario;
  }

  void sair() {
    _usuario = null;
  }
}
