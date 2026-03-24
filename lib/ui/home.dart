import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cart_api_whats_2026/core/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../core/janelas.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> produtos = [];
  List<dynamic> filtrados = [];
  List<String> categorias = [];
  List<dynamic> carrinho = [];
  String usuario = '';
  String avatar = '';

  @override
  void initState() {
    super.initState();
    verificarSeEstaLogado();
  }

  Future<void> verificarSeEstaLogado() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_data')) {
      setState(() {
        usuario = json.decode(prefs.getString('user_data')!)['nome'];
      });
      if (json.decode(prefs.getString('user_data')!)['avatar'] != null) {
        setState(() {
          avatar = json.decode(prefs.getString('user_data')!)['avatar'];
        });
      }
      await carrearProdutosAPI();
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> carrearProdutosAPI() async {
    final url = Uri.parse(Api.getProdutos().toString());
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        produtos = await json.decode(response.body);
        setState(() {
          filtrados = produtos;
        });
        filtraCategorias();
      } else {
        msgDialog('Erro de conexão', response.body);
      }
    } catch (e) {
      msgDialog("Erro de conexão", e.toString());
    }
  }

  void filtraCategorias() {
    produtos.forEach((p) {
      if (!categorias.contains(p['categoria'])) {
        setState(() {
          categorias.add(p['categoria']);
        });
      }
    });
  }

  ClipRRect userAvatar(String img) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: img == ''
          ? Icon(Icons.account_circle, size: 40.0, color: AppColors.c4)
          : Image.network(img, width: 50, height: 50, fit: BoxFit.cover),
    );
  }

  void msgDialog(String titulo, String msg) {
    if (mounted) {
      Janelas.msgDialog(titulo, msg, context);
    }
  }

  void verDetalhes(int indice) {
    if (mounted) {
      Janelas.detalhes(
        context,
        filtrados[indice]['nome'],
        filtrados[indice]['imagem'],
        filtrados[indice]['descricao'],
        filtrados[indice]['preco'].toString(),
      );
    }
  }

  Future<void> sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    verificarSeEstaLogado();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(usuario, style: TextStyle(color: AppColors.c4)),
          backgroundColor: AppColors.c1,
          toolbarHeight: 70.0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: userAvatar(avatar),
            ),
            ElevatedButton(onPressed: () => sair(), child: Text("Sair")),
          ],
        ),
        body: TabBarView(
          children: [
            Center(
              child: GridView.builder(
                itemBuilder: (context, i) => GestureDetector(
                  onTap: () => verDetalhes(i),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.c3,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.t1, // Cor da sombra
                          spreadRadius: 3, // Extensão
                          blurRadius: 5, // Desfoque
                          offset: Offset(1, 0), // Posição (x, y)
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(filtrados[i]['imagem'], width: 100),
                          Text(
                            "Id:${filtrados[i]['id']}, ${filtrados[i]['nome']}",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(filtrados[i]['categoria']),
                              Text(
                                filtrados[i]['preco'].toStringAsFixed(2),
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.9,
                ),
                itemCount: filtrados.length,
              ),
            ),
            Center(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int i) => ListTile(
                  leading: Image.network(carrinho[i]['imagem']),
                  title: Text(
                    "Id:${carrinho[i]['id']}, ${carrinho[i]['nome']}",
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(carrinho[i]['preco']),
                      Text(carrinho[i]['quantidade']),
                    ],
                  ),
                  trailing: Text(
                    produtos[i]['subtotal'].toStringAsFixed(2),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                itemCount: carrinho.length,
              ),
            ),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: "Produtos"),
            Tab(icon: Icon(Icons.shopping_cart), text: "Carrinho"),
          ],
        ),
      ),
    );
  }
}
