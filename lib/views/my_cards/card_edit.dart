import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:visite3000/globals.dart' as globals;

import '../../models/card.dart';

class CardEdit extends StatelessWidget {
  final int cardId;
  CardEdit({super.key, required this.cardId});

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

  Future<bool> saveDatas() async {
    Map data = {
      'cardId': cardId,
      'role': roleController.text, 
      'phone': phoneController.text,
      'mail': mailController.text
    };
    String body = jsonEncode(data);
    
    Response response = await http.post(
      Uri.parse('${globals.serverEntryPoint}/db/update_card.php'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    );

    if (response.statusCode == 200){
      return true;
    }
    else {
      return false;
    }
  }

  void confirmCancel(BuildContext context){
    Widget cancelButton = TextButton(
      child: const Text("NOOOOOOO!"),
      onPressed:  () => Navigator.pop(context),
      
    );
    Widget continueButton = TextButton(
      child: const Text("I'm sure"),
      onPressed:  () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Cancel ?"),
      content: const Text("Changes will not be saved."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  TextEditingController roleController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, 
      backgroundColor: Colors.pink,
      body: FutureBuilder(
        future: getCardDatas(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            roleController.text = snapshot.data!.role;
            phoneController.text = snapshot.data!.phone;
            mailController.text = snapshot.data!.mail;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image(
                        image: NetworkImage("${globals.serverEntryPoint}/cards/$cardId.png"),
                      ),
                      Column(
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
                              child: Column(
                                children:
                                [
                                  CardFormEntryEdit(title: "Role", controller: roleController),
                                  CardFormEntryEdit(title: "Phone", controller: phoneController, isPhone: true,),
                                  CardFormEntryEdit(title: "Mail", controller: mailController, isMail: true,),
                                ]
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  fixedSize: const Size(120, 50),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30))
                                  )
                                ),
                                onPressed: () => confirmCancel(context),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 25
                                  ),
                                )
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  fixedSize: const Size(120, 50),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30))
                                  )
                                ),
                                onPressed: () {
                                  saveDatas().then((validation) {
                                    if (validation){
                                      Navigator.pop(context);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => const AlertDialog(
                                          elevation: 0,
                                          content: Text(
                                            "Can't save the datas",
                                            textAlign: TextAlign.center,
                                          ),
                                          icon: Icon(Icons.signal_wifi_connected_no_internet_4_rounded),
                                        )
                                      );
                                    }
                                  });
                                } ,
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize: 25
                                  ),
                                )
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Align(
              alignment: Alignment.center,
              child: SpinKitCubeGrid(
                color: Colors.white,
                size: 60,
              ),
            );
          }
        }
      )
    );
  }

}


class CardFormEntryEdit extends StatelessWidget{
  final String title;
  final TextEditingController controller;
  
  final bool isMail;
  final bool isPhone;

  const CardFormEntryEdit({super.key, required this.title, required this.controller, this.isPhone = false, this.isMail = false});
  
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
                scrollPadding: EdgeInsets.only(bottom: 120),
                decoration: null,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold
                ),
                controller: controller,
              )
            )
          )
        ],
      ),
    );
  }

}
  