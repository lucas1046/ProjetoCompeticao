import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final String texto;
  final void Function()? onPressed;

  Buttons(this.texto, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(texto, style: TextStyle(fontSize: 16)),
    );
  }
}
