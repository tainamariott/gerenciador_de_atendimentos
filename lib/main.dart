import 'package:flutter/material.dart';
import 'pages/lista_atendimentos_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Atendimentos',
      home: const ListaAtendimentosPage(),
    );
  }
}