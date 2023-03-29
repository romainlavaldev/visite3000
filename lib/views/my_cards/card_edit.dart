import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:visite3000/globals.dart' as globals;

import '../../models/card.dart';

class CardEdit extends StatelessWidget {
  final int cardId;
  const CardEdit({super.key, required this.cardId});

  Future<CardModel> getCardDatas() async {
    Map data = {'cardId': cardId};
    String body = jsonEncode(data);
    
    Response response = await http.post(
      Uri.parse('${globals.serverEntryPoint}/db/get_card.php'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    );

    if (response.statusCode == 200){
      dynamic jsonData = json.decode(response.body);

      return CardModel(
        cardId,
        jsonData["datas"][0]["phone"] ?? "",
        jsonData["datas"][0]["mail"] ?? "",
        jsonData["datas"][0]["role"] ?? "",
        jsonData["datas"][0]["firstname"] ?? "",
        jsonData["datas"][0]["lastname"] ?? "",
      );
    }

    return CardModel(
      0,
      "Card not found",
      "Card not found",
      "Card not found",
      "Card not found",
      "Card not found"
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Column(
            children: [
              Image(
                image: NetworkImage("${globals.serverEntryPoint}/cards/$cardId.png"),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.pink,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 5
                        ),
                        child: SingleChildScrollView(
                          child: FutureBuilder(
                            future: getCardDatas(),
                            builder: (context, snapshot) {
                              return Column(
                                children: snapshot.hasData ? 
                                [
                                  CardFormEntryEdit(title: "Firstname", value: snapshot.data!.firstname),
                                  CardFormEntryEdit(title: "Lastname", value: snapshot.data!.lastName),
                                  CardFormEntryEdit(title: "Role", value: snapshot.data!.role),
                                  CardFormEntryEdit(title: "Phone", value: snapshot.data!.phone, isPhone: true,),
                                  CardFormEntryEdit(title: "Mail", value: snapshot.data!.mail, isMail: true,),
                                ] : []
                              );
                            }
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white
                          ),
                          onPressed: (){},
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 25
                            ),
                          )
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white
                          ),
                          onPressed: (){},
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 25
                            ),
                          )
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}


class CardFormEntryEdit extends StatelessWidget{
  final String title;
  final String value;
  
  final bool isMail;
  final bool isPhone;

  const CardFormEntryEdit({super.key, required this.title, required this.value, this.isPhone = false, this.isMail = false});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 197, 25, 82),
              borderRadius: BorderRadius.circular(5)
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: null,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold
                ),
                controller: TextEditingController(text: value),
              )
            )
          )
        ],
      ),
    );
  }

}
  