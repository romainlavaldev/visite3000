import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'globals.dart' as globals;

import 'package:tuple/tuple.dart';

class Share extends StatefulWidget
{
  const Share({super.key});

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share>
{
  final _storage = const FlutterSecureStorage();
  String qrData = "";

  Future<List<Tuple2<int, ShareCardTile>>> getUserCards() async {
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

      List<Tuple2<int, ShareCardTile>> cards = <Tuple2<int, ShareCardTile>>[];

      for (dynamic card in jsonData['datas']) {
        int cardId = int.parse(card['id']);
        cards.add(Tuple2(cardId, ShareCardTile(cardId: cardId)));
      }

      return cards;
    }

    return [];
  }

  void generateQR(String data){
    setState(() {
      qrData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: FutureBuilder(
        future: getUserCards(),
        builder: (context, snapshot) {
          return snapshot.hasData ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: SizedBox(
                  height: 195,
                  child: ScrollSnapList(
                    scrollDirection: Axis.horizontal,
                    itemSize: 320,
                    itemCount: snapshot.data!.length,
                    onItemFocus: (index) {
                      generateQR(snapshot.data![index].item1.toString());
                    },
                    itemBuilder: (context, index) {
                      Widget card = snapshot.data![index].item2;
                      return card;
                    },
                  ),
                ),
              ),
              Column(
                children: [
                  const Text(
                    "Scan to add to your wallet",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 50,
                      left: 50,
                      right: 50,
                      top: 20
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(40))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: QrImage(data: qrData),
                      )
                    ),
                  ),
                ],
              )
            ],
          ) : const Center(
            child: SpinKitCubeGrid(
              color: Colors.white,
              size: 60,
            ),
          );
        },
      ),
    );
  }
}

class ShareCardTile extends StatelessWidget{
  final int cardId;
  const ShareCardTile({super.key, required this.cardId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image(
            image: NetworkImage("${globals.serverEntryPoint}/cards/$cardId.png"),
          ),
        ),
      ),
    );
  }

}