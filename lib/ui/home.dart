import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cart_api_whats_2026/core/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api.dart';
import 'widgets/janelas.dart';

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
    for (var p in produtos) {
      if (!categorias.contains(p['categoria'])) {
        setState(() {
          categorias.add(p['categoria']);
        });
      }
    }
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

  Future<void> verDetalhes(int indice) async {
    if (mounted) {
      if (await Janelas.detalhes(
        context,
        filtrados[indice]['nome'],
        filtrados[indice]['imagem'],
        filtrados[indice]['descricao'],
        filtrados[indice]['preco'].toString(),
      )) {
        final dynamic item = {
          'id': filtrados[indice]['id'],
          'imagem': filtrados[indice]['imagem'],
          'nome': filtrados[indice]['nome'],
          'preco': filtrados[indice]['preco'],
          'quantidade': 1,
          'subtotal': filtrados[indice]['preco'],
        };
        if (carrinho.any((element) => element['id'] == item['id'])) {
          setState(() {
            carrinho = carrinho.map((element) {
              if (element['id'] == item['id']) {
                element['quantidade'] += 1;
                element['subtotal'] = element['quantidade'] * element['preco'];
              }
              return element;
            }).toList();
          });
        } else {
          setState(() {
            carrinho.add(item);
          });
        }
      }
    }
  }

  String totalCarrinho() {
    double total = 0;
    for (var item in carrinho) {
      total += item['subtotal'];
    }
    return "R\$ ${total.toStringAsFixed(2)}";
  }

  Future<void> enviarPedido() async {
    // Lógica para enviar o pedido via mensagem no whatsapp
    String mensagem = "Olá, gostaria de fazer um pedido:\n";
    for (var item in carrinho) {
      mensagem +=
          "- ${item['nome']} (Quantidade: ${item['quantidade']}) - R\$ ${item['subtotal'].toStringAsFixed(2)}\n";
    }
    // Lógica para abrir o WhatsApp com a mensagem pré-preenchida
    final uri = Uri.parse(
      "https://wa.me/19991866605?text=${Uri.encodeComponent(mensagem)}",
    );
    final abriu = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!abriu) {
      msgDialog('Erro', 'Nao foi possivel abrir o WhatsApp.');
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
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            filtrados = produtos;
                          });
                        },
                        child: Container(
                          height: 70,
                          margin: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 5,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: AppColors.c2,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              "Todos",
                              style: TextStyle(color: AppColors.c4),
                            ),
                          ),
                        ),
                      ),

                      for (var c in categorias)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              filtrados = produtos
                                  .where((p) => p['categoria'] == c)
                                  .toList();
                            });
                          },
                          child: Container(
                            height: 70,
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: AppColors.c2,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                c,
                                style: TextStyle(color: AppColors.c4),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(filtrados[i]['imagem'], width: 80),
                              Text(
                                "Id:${filtrados[i]['id']}, ${filtrados[i]['nome']}",
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: filtrados.length,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int i) => Container(
                      decoration: BoxDecoration(
                        color: AppColors.c4,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.t2,
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(1, 0),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Image.network(carrinho[i]['imagem']),
                        title: Text(
                          "Id:${carrinho[i]['id']}, ${carrinho[i]['nome']}",
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (carrinho[i]['quantidade'] > 1) {
                                        carrinho[i]['quantidade'] -= 1;
                                        carrinho[i]['subtotal'] =
                                            carrinho[i]['quantidade'] *
                                            carrinho[i]['preco'];
                                      } else {
                                        carrinho.removeAt(i);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.c3,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text("-"),
                                  ),
                                ),
                                Text(carrinho[i]['quantidade'].toString()),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      carrinho[i]['quantidade'] += 1;
                                      carrinho[i]['subtotal'] =
                                          carrinho[i]['quantidade'] *
                                          carrinho[i]['preco'];
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.c3,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text("+"),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'R\$ ${carrinho[i]['preco'].toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        trailing: Text(
                          'R\$ \n${carrinho[i]['subtotal'].toStringAsFixed(2)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    itemCount: carrinho.length,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.c4,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.t2,
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(1, 0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Total: ${totalCarrinho()}"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  carrinho = [];
                                });
                              },
                              child: Text("Limpar carrinho"),
                            ),
                            ElevatedButton(
                              onPressed: () => enviarPedido(),
                              child: Text("Eviar pedido"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
