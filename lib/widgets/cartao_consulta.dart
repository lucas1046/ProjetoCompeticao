import 'package:flutter/material.dart';

class CartaoConsulta extends StatelessWidget {
  final String titulo;
  final List<String> linhas;
  final String? selo;
  final Color? corSelo;
  final IconData? icone;
  final VoidCallback? onTap;

  const CartaoConsulta(
    this.titulo,
    this.linhas, {
    super.key,
    this.selo,
    this.corSelo,
    this.icone,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icone != null) ...[
                    Icon(icone, size: 20, color: Colors.blue),
                    SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (selo != null && selo!.isNotEmpty)
                    Text(
                      selo!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: corSelo ?? Colors.black,
                      ),
                    ),
                ],
              ),
              for (String linha in linhas) ...[
                SizedBox(height: 4),
                Text(linha),
              ],
            ],
          ),
        ),
      ),
    );
  }
}