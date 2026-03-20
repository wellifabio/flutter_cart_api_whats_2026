import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api.dart';
import '../core/colors.dart';
import '../core/janelas.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<dynamic> usuarios = [];
  String email = '';
  String senha = '';

  @override
  void initState() {
    super.initState();
    carrearUsuariosAPI();
  }

  Future<void> carrearUsuariosAPI() async {
    final url = Uri.parse('${Api.getUsuarios()}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        usuarios = json.decode(response.body);
      } else {
        msgDialog('Erro de conexão', response.body);
      }
    } catch (e) {
      msgDialog("Erro de conexão", e.toString());
    }
    verificarSeJaEstaLogado();
  }

  Future<void> verificarSeJaEstaLogado() async {
    final localStorage = await SharedPreferences.getInstance();
    if (localStorage.containsKey('user_data')) {
      toHome();
    }
  }

  Future<void> salvarPerfil(int indice) async {
    final localStorage = await SharedPreferences.getInstance();
    await localStorage.setString('user_data', json.encode(usuarios[indice]));
    toHome();
  }

  void toHome() {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  void entrar() {
    int indice = -1;
    indice = usuarios.indexWhere((user) => user['email'] == email);
    if (indice != -1) {
      if (usuarios[indice]['senha'] == senha) {
        salvarPerfil(indice);
      } else {
        msgDialog("Erro", "Senha inválda.");
      }
    } else {
      msgDialog("Erro", "E-mail não encontrado.");
    }
  }

  void msgDialog(String titulo, String msg) {
    if (mounted) {
      Janelas.msgDialog(titulo, msg, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c3,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20.0,
          children: [
            Image.asset('assets/favicon.png', width: 150),
            Material(
              elevation: 8.0, // Intensidade da sombra
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                style: TextStyle(color: AppColors.c1),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.c2, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.c1, width: 2.0),
                  ),
                  labelText: 'E-mail',
                  hintText: 'usuario@email.com',
                  suffixStyle: TextStyle(color: AppColors.c1),
                  labelStyle: TextStyle(color: AppColors.c1),
                  hintStyle: TextStyle(color: AppColors.c2),
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Material(
              elevation: 8.0, // Intensidade da sombra
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                style: TextStyle(color: AppColors.c1),
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.c2, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.c1, width: 2.0),
                  ),
                  labelText: 'Senha',
                  hintText: 'senha123',
                  suffixStyle: TextStyle(color: AppColors.c1),
                  labelStyle: TextStyle(color: AppColors.c1),
                  hintStyle: TextStyle(color: AppColors.c2),
                ),
                onChanged: (value) {
                  senha = value;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => entrar(),
              style: ElevatedButton.styleFrom(
                elevation: 8.0,
                backgroundColor: AppColors.c3,
              ),
              child: Text(
                "Entrar",
                style: TextStyle(
                  color: AppColors.c1,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
