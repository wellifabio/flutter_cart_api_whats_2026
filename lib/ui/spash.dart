import 'dart:async';

import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _scaleAumenta, _scaleDiminui;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();

    _scaleAumenta =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addListener(() {
            setState(() {
              _scale = _scaleAumenta.value;
            });
          });

    _scaleDiminui =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addListener(() {
            setState(() {
              _scale = 1.0 - _scaleDiminui.value;
            });
          });

    _scaleAumenta.forward();

    Timer(const Duration(seconds: 3), () {
      _scaleDiminui.forward();
    });

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scaleAumenta.dispose();
    _scaleDiminui.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c2,
      body: Center(
        child: Transform.scale(
          scale: _scale,
          child: Image.asset('assets/favicon.png', width: 400, height: 400),
        ),
      ),
    );
  }
}
