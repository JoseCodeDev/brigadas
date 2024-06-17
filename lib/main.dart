import 'package:flutter/material.dart';
import 'screens/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _rutas = {
    "/": (context) => const HomeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: _rutas,
    );
  }
}
