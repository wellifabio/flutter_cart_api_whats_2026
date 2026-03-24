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

  static bool detalhes(
    BuildContext context,
    String produto,
    String img,
    String descricao,
    String preco,
  ) {
    bool result = false;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(produto),
        content: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.network(img), Text(descricao), Text(preco)],
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text("Adicionar ao carrinho"),
            onPressed: () {
              result = true;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
    return result;
  }
}
