import 'package:flutter/material.dart';

abstract class Janelas {
  static void msgDialog(String titulo, String msg, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(msg),
        actions: [
          ElevatedButton(
            child: Text("Fechar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
