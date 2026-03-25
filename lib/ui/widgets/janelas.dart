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

  static Future<bool> detalhes(
    BuildContext context,
    String produto,
    String img,
    String descricao,
    String preco,
  ) async {
    bool result = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(produto),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(img),
            Center(child: Text(descricao)),
            Text(preco),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: Text("Canelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text("Comprar"),
                onPressed: () {
                  result = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
    return result;
  }
}
