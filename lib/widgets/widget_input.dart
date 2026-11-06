import 'package:flutter/material.dart';

class InputTextos extends StatelessWidget {
  String rotulo;
  String label;
  TextEditingController controller;
  bool senha;

  InputTextos(
    this.rotulo,
    this.label, {super.key, 
    required this.controller,
    this.senha = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      obscureText: senha,
      style: TextStyle(
        color: Colors.black,
        backgroundColor: Colors.white,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
