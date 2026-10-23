import 'package:flutter/material.dart';

/// RNFR-13.3 — status financeiro do jogador (pago, parcial ou pendente).
/// Centralizado aqui para ser usado na tela de inscrição e nos relatórios.
class Financeiro {
  static const String pago = "PAGO";
  static const String parcial = "PARCIAL";
  static const String pendente = "PENDENTE";

  /// Define o status a partir do valor da inscrição e do quanto já foi pago
  static String status(double valorInscricao, double valorPago) {
    if (valorPago <= 0) {
      return pendente;
    }
    if (valorPago < valorInscricao) {
      return parcial;
    }
    return pago;
  }

  /// Cor usada para destacar o status na interface
  static Color cor(String status) {
    switch (status) {
      case pago:
        return Colors.green;
      case parcial:
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
