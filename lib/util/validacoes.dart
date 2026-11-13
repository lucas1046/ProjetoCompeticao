import 'package:projeto_final/util/formatador.dart';

/// Exceção lançada quando uma regra de negócio é violada.
/// RNFRs do documento de requisitos.
class RegraNegocioException implements Exception {
  final String mensagem;

  RegraNegocioException(this.mensagem);

  @override
  String toString() => mensagem;
}

/// Utilitários de validação usados pelas regras de negócio.
class Validacoes {
  // ---------------------------------------------------------
  // CPF
  // ---------------------------------------------------------

  /// RNFR-05.1 / RNFR-16.1 — Valida CPF (formato e dígitos verificadores)
  static bool cpfValido(String cpf) {
    String numeros = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length != 11) {
      return false;
    }

    // Rejeita CPFs com todos os dígitos iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(numeros)) {
      return false;
    }

    // Primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(numeros[i]) * (10 - i);
    }
    int resto = (soma * 10) % 11;
    if (resto == 10) resto = 0;
    if (resto != int.parse(numeros[9])) {
      return false;
    }

    // Segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(numeros[i]) * (11 - i);
    }
    resto = (soma * 10) % 11;
    if (resto == 10) resto = 0;

    return resto == int.parse(numeros[10]);
  }

  // ---------------------------------------------------------
  // DATA
  // ---------------------------------------------------------

  /// Verifica se a data está em dd/MM/yyyy (ou AAAA-MM-DD, aceito por
  /// compatibilidade) e é válida.
  static bool dataValida(String data) => Formatador.dataValida(data);

  /// RNFR-06.1 — Calcula a idade a partir da data de nascimento
  static int calcularIdade(String dataNascimento) {
    DateTime nascimento = Formatador.paraDateTime(dataNascimento)!;
    DateTime hoje = DateTime.now();
    int idade = hoje.year - nascimento.year;

    if (hoje.month < nascimento.month ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      idade--;
    }
    return idade;
  }

  /// RNFR-08.1 — Verifica se uma data está dentro de um período
  static bool dentroDoPeriodo(String data, String inicio, String fim) {
    DateTime d = Formatador.paraDateTime(data)!;
    return !d.isBefore(Formatador.paraDateTime(inicio)!) &&
        !d.isAfter(Formatador.paraDateTime(fim)!);
  }

  // ---------------------------------------------------------
  // IMAGEM (RNFR-03.2)
  // ---------------------------------------------------------

  /// RNFR-03.2 — tamanho máximo de 5 MB em bytes
  static const int tamanhoMaximoImagem = 5 * 1024 * 1024;

  /// RNFR-03.2 — extensões de imagem permitidas
  static const List<String> extensoesImagemPermitidas = [
    ".jpg",
    ".jpeg",
    ".png",
    ".webp",
  ];

  /// RNFR-03.2 — verifica se o caminho termina em uma extensão permitida
  static bool extensaoImagemPermitida(String caminho) {
    String extensao =
        caminho.substring(caminho.lastIndexOf(".")).toLowerCase();
    return caminho.contains(".") &&
        extensoesImagemPermitidas.contains(extensao);
  }

  /// RNFR-03.2 — mensagem usada quando a extensão não é permitida
  static String mensagemExtensaoImagem() {
    String formatos = extensoesImagemPermitidas
        .map((e) => e.replaceFirst(".", "").toUpperCase())
        .join(", ");
    return "Formato de imagem inválido. Use $formatos.";
  }

  // ---------------------------------------------------------
  // TEXTO
  // ---------------------------------------------------------

  /// Verifica se o texto não está vazio (após remover os espaços das pontas)
  static bool textoPreenchido(String texto) => texto.trim().isNotEmpty;

  /// Monta o texto de uma lista de erros, ou null quando não há erros
  static String? listaErros(List<String> erros) {
    erros.removeWhere((e) => e.isEmpty);
    return erros.isEmpty ? null : erros.join("\n");
  }
}
