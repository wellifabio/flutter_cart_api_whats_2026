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
      carrearProdutosAPI();
      setState(() {
        usuario = json.decode(prefs.getString('user_data')!)['nome'];
        avatar = json.decode(prefs.getString('user_data')!)['avatar'];
      });
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> carrearProdutosAPI() async {
    final url = Uri.parse('${Api.getProdutos()}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        produtos = json.decode(response.body);
      } else {
        msgDialog('Erro de conexão', response.body);
      }
    } catch (e) {
      msgDialog("Erro de conexão", e.toString());
    }
  }

  ClipRRect userAvatar(String img) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: img == ''
          ? Image.asset('assets/user.png', width: 50, height: 50)
          : Image.network(img, width: 50, height: 50, fit: BoxFit.cover),
    );
  }

  void msgDialog(String titulo, String msg) {
    if (mounted) {
      Janelas.msgDialog(titulo, msg, context);
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
            Center(child: Text('Produtos')),
            Center(child: Text('Carrinho')),
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
