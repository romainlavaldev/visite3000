import 'package:flutter/material.dart';

class MyCards extends StatefulWidget
{
  const MyCards({super.key});

  @override
  State<MyCards> createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards>
{
  @override
  Widget build(BuildContext context) {
    return const Text("Welcome to ze casa");
  }
}