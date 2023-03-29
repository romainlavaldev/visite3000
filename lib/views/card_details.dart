import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visite3000/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/card.dart';

class CardDetails extends StatefulWidget{
  final int cardId;
  const CardDetails({super.key, required this.cardId});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {

  Future<CardModel> getCardDatas() async {
    Map data = {'cardId': widget.cardId};
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
        widget.cardId,
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
      body: FutureBuilder(
        future: getCardDatas(),
        builder: (context, snapshot) {
          return snapshot.hasData ? SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Image(
                    image: NetworkImage("${globals.serverEntryPoint}/cards/${widget.cardId}.png"),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context), 
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 25,
                    ),
                  )
                ],
              ),
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
                    child: Column(
                      children: [
                        CardFormEntryReadOnly(title: "Firstname", value: snapshot.data!.firstname),
                        CardFormEntryReadOnly(title: "Lastname", value: snapshot.data!.lastName),
                        CardFormEntryReadOnly(title: "Role", value: snapshot.data!.role),
                        CardFormEntryReadOnly(title: "Phone", value: snapshot.data!.phone, isPhone: true,),
                        CardFormEntryReadOnly(title: "Mail", value: snapshot.data!.mail, isMail: true,),
                      ]
                    )
                  ),
                ),
              )
            ],
          ),
        ) : const Align(
            alignment: Alignment.center,
            child: SpinKitCubeGrid(
              color: Colors.white,
              size: 60,
            ),
          );
        }
      ),
    );
  }
}

class CardFormEntryReadOnly extends StatelessWidget{
  final String title;
  final String value;
  
  final bool isMail;
  final bool isPhone;

  const CardFormEntryReadOnly({super.key, required this.title, required this.value, this.isPhone = false, this.isMail = false});

  void copyContent(BuildContext context){
    Clipboard.setData(ClipboardData(text: value)).then((value) => {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to your clipboard !'))
      )
    });
  }

  void callPhone(String phoneNumber) async {
    Uri phoneUri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(phoneUri)){
      await launchUrl(phoneUri);
      print("ok");
    } else {
      print("pas ok");
    }
  }

  void sendSms(String phoneNumber) async {
    Uri phoneUri = Uri.parse('sms:$phoneNumber');
    if (await canLaunchUrl(phoneUri)){
      await launchUrl(phoneUri);
      print("ok");
    } else {
      print("pas ok");
    }
  }

  void sendMail(String mail) async{
    Uri mailUri = Uri.parse('mailto:$mail');
    if (await canLaunchUrl(mailUri)){
      await launchUrl(mailUri);
      print("ok");
    } else {
      print("pas ok");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty){
      return const SizedBox(width: 0);
    }
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (isPhone) IconButton(
                        onPressed: () => callPhone(value),
                        icon: Icon(
                          Icons.phone,
                          color: Colors.white.withOpacity(0.75),
                        )
                      ),
                      if (isPhone) IconButton(
                        onPressed: () => sendSms(value),
                        icon: Icon(
                          Icons.sms,
                          color: Colors.white.withOpacity(0.75),
                        )
                      ),
                      if (isMail) IconButton(
                        onPressed: () => sendMail(value),
                        icon: Icon(
                          Icons.mail,
                          color: Colors.white.withOpacity(0.75),
                        )
                      ),
                      IconButton(
                        onPressed: () => copyContent(context),
                        icon: Icon(
                          Icons.content_copy_rounded,
                          color: Colors.white.withOpacity(0.75),
                          
                        )
                      ),
                    ],
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }

}