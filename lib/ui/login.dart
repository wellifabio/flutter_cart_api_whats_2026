import 'package:flutter/material.dart';
import '../core/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<dynamic> usuarios = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c2,
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
              ),
            ),
            ElevatedButton(
              onPressed: () {},
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
