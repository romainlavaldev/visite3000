import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:visite3000/globals.dart' as globals;

class ScoreBoard extends StatefulWidget{
  const ScoreBoard({super.key});

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {

  List<Widget> scoreList = <Widget>[];

  Future<void> getScoreboard() async {
    
    Response response = await http.post(
      Uri.parse('${globals.serverEntryPoint}/db/get_game_scores.php'),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    );

    if (response.statusCode == 200){
      dynamic jsonData = json.decode(response.body);

      
      for (dynamic score in jsonData['datas']) {
        
        scoreList.add(Text("name : ${score['name']} - ${score['displayTime']}"));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getScoreboard().whenComplete(() {
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: ListView(
        children: scoreList.map((score) => 
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 3
          ),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: score,
            )
          ),
        )
      ).toList(),
      ),
    );
  }
}