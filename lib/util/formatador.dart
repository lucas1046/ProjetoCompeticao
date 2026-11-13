/// Formatação de datas no padrão brasileiro (dd/MM/yyyy).
///
/// O banco continua guardando as datas em AAAA-MM-DD (ISO) porque as
/// comparações e ordenações SQL dependem disso. Esta classe faz a conversão
/// na fronteira: entrada do usuário e exibição.
class Formatador {
  /// Converte AAAA-MM-DD para dd/MM/yyyy.
  /// Valores já em dd/MM/yyyy ou inválidos são devolvidos sem alteração.
  static String dataBr(String valor) {
    final v = valor.trim();
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(v);
    if (m == null) return v;
    return '${m.group(3)}/${m.group(2)}/${m.group(1)}';
  }

  /// Converte dd/MM/yyyy para AAAA-MM-DD (formato do banco).
  /// Valores já em AAAA-MM-DD são devolvidos sem alteração.
  static String dataIso(String valor) {
    final v = valor.trim();
    final m = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(v);
    if (m == null) return v;
    return '${m.group(3)}-${m.group(2)}-${m.group(1)}';
  }

  /// Converte um timestamp ISO (AAAA-MM-DDTHH:MM:SS...) para dd/MM/yyyy HH:mm.
  static String dataHoraBr(String valor) {
    final v = valor.trim();
    final m =
        RegExp(r'^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2})').firstMatch(v);
    if (m == null) return v;
    return '${m.group(3)}/${m.group(2)}/${m.group(1)} ${m.group(4)}:${m.group(5)}';
  }

  /// Aceita dd/MM/yyyy (padrão brasileiro) ou AAAA-MM-DD (legado).
  static bool dataValida(String valor) {
    final v = valor.trim();
    final m = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(v);
    final iso = m == null ? RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(v) : null;

    int dia;
    int mes;
    int ano;
    if (m != null) {
      dia = int.parse(m.group(1)!);
      mes = int.parse(m.group(2)!);
      ano = int.parse(m.group(3)!);
    } else if (iso != null) {
      ano = int.parse(iso.group(1)!);
      mes = int.parse(iso.group(2)!);
      dia = int.parse(iso.group(3)!);
    } else {
      return false;
    }

    if (mes < 1 || mes > 12 || dia < 1 || dia > 31) return false;

    // DateTime normaliza dias fora do alcance (ex.: 32 -> 1), entao a
    // comparação por igualdade detecta dia/mês inexistentes.
    final dt = DateTime(ano, mes, dia);
    return dt.year == ano && dt.month == mes && dt.day == dia;
  }

  /// Converte para DateTime, aceitando dd/MM/yyyy ou AAAA-MM-DD.
  static DateTime? paraDateTime(String valor) {
    final v = valor.trim();
    final m = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(v);
    final iso = m == null ? v : '${m.group(3)}-${m.group(2)}-${m.group(1)}';
    return DateTime.tryParse(iso);
  }
}
