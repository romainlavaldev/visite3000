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

  List<Widget> scoreList = List<Widget>.empty();

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
      body: ListView(
        children: scoreList,
      ),
    );
  }
}