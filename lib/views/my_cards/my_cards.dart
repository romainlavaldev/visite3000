import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:visite3000/globals.dart' as globals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:visite3000/views/my_cards/card_add.dart';
import 'package:visite3000/views/my_cards/card_edit.dart';

class MyCards extends StatefulWidget{
  const MyCards({super.key});

  @override
  State<MyCards> createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  final _storage = const FlutterSecureStorage();

  Future<List<Widget>> getUserCards() async {
    Map data = {'userId': await _storage.read(key: "UserId")};
    String body = jsonEncode(data);
    
    Response response = await http.post(
      Uri.parse('${globals.serverEntryPoint}/db/get_user_cards.php'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    );

    if (response.statusCode == 200){
      dynamic jsonData = json.decode(response.body);

      List<Widget> cards = <Widget>[];

      if (jsonData['datas'] != null) {
        for (dynamic card in jsonData['datas']) {
          cards.add(MyCardTile(cardId: int.parse(card['id']), myCardRefresh: refresh));
        }
      }
      cards.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (builder) => const CardAdd())
            ).then((code) {
              if (code == 1 ) { 
                refresh();
              }
            });
          },
          child: MyCardTile(cardId: int.parse("0"), isAddCard: true, myCardRefresh: refresh)
        )
      );

      return cards;
    }

    return [];
  }

  void refresh(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.pink,
      body: FutureBuilder(
        future: getUserCards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.hasData ? ListView(
              children: snapshot.data ?? [],
            ) : const Center(
              child: SpinKitCubeGrid(
                color: Colors.white,
                size: 60,
              ),
            );
          } else {
            return const Center(
              child: SpinKitCubeGrid(
                color: Colors.white,
                size: 60,
              ),
            );
          }
        },
      )
    );
  }
}

class MyCardTile extends StatelessWidget{
  final int cardId;
  final bool isAddCard;
  final Function myCardRefresh;
  const MyCardTile({super.key, required this.cardId, required this.myCardRefresh, this.isAddCard = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 15
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image(
              image: NetworkImage("${globals.serverEntryPoint}/cards/$cardId.png"),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [ BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: const Offset(0, 0)
                  )]
                ),
                child: !isAddCard ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (builder) => CardEdit(cardId: cardId))
                      ).then((code) {
                        if (code == 1 ) { 
                          myCardRefresh();
                        }
                      }),
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      )
                    )
                  ],
                ) : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}