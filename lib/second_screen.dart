import 'package:flutter/material.dart';
class SecondRoute extends StatefulWidget {
  const SecondRoute({super.key});

  @override
  State<SecondRoute> createState() => _SecondState();
}

class _SecondState extends State<SecondRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(child: Text("Hello")),);
  }
}