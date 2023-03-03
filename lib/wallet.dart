import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class Wallet extends StatefulWidget
{
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet>
{
  final _storage = const FlutterSecureStorage();
  List<Widget> _cardList = List<Widget>.empty();

  Future<void> _getUserCards() async {
    Map data = {'userId': await _storage.read(key: "UserId")};
    String body = jsonEncode(data);
    
    Response response = await http.post(
      Uri.parse('http://192.168.1.100:8001/visite3000/get_user_cards.php'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    );

    if (response.statusCode == 200){
      dynamic jsonData = json.decode(response.body);

      List<Widget> cards = <Widget>[];

      for (dynamic card in jsonData['data']) {
        Widget cardWidget = Text("Card ${card['CardId']} from user ${card['CardOwner']}");
      
        cards.add(cardWidget);
      }

      _cardList = cards;

    }
  }

  @override
  void initState() {
    super.initState();
    _getUserCards().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _cardList
    );
  }
}