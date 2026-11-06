import 'package:flutter/material.dart';

class TextosCustom extends StatelessWidget {
  String seuTexto;
  double fontSize;
  Color fontColor;

  TextosCustom(this.seuTexto, this.fontSize, this.fontColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      seuTexto,
      softWrap: true,
      style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
      ),
    );
  }
}
