import 'package:flutter/material.dart';

class Wallet extends StatefulWidget
{
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet>
{
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Text("Carte de visite 1"),
        Text("Carte de visite 2"),
        Text("Carte de visite 3"),
        Text("Carte de visite 4"),
        Text("Carte de visite 5")
      ],
    );
  }
}