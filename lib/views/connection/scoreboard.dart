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

  Future<List<Widget>> getScoreboard() async {

    Response response = await http.post(
      Uri.parse('${globals.serverEntryPoint}/db/get_game_scores.php'),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    );

    if (response.statusCode == 200){
      dynamic jsonData = json.decode(response.body);
      List<Widget> scoreList = <Widget>[];

      int rank = 1;
      if (jsonData['datas'] == null){
        return <Widget>[];  
      }


      for (dynamic score in jsonData['datas']) {
        Widget entry = ScoreBoardEntry(
          name: score['name'], 
          score: score['displayTime'],
          rank: rank
        );

        scoreList.add(entry);

        rank += 1;
      }

      return scoreList;
    }

    return <Widget>[];
  }

  @override
  void initState() {
    super.initState();
    getScoreboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            const Text(
              "Scoreboard",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.pink
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ScrollConfiguration(
                    behavior: globals.MyBehavior(),
                    child: FutureBuilder(
                      future: getScoreboard(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        return ListView(
                          children: snapshot.hasData ? snapshot.data : [],
                        );
                      }
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}


class ScoreBoardEntry extends StatelessWidget {
  final String name;
  final String score;
  final int rank;

  const ScoreBoardEntry({super.key, required this.name, required this.score, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color.fromRGBO(230, 230, 230, 0.5))
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: getRankColor(rank),
                    shape: BoxShape.circle
                  ),
                  child: Text(
                    rank.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                )
              ],
            ),
            Text(
              score,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getRankColor(int rank){
    switch (rank) {
      case 1:
        return const Color.fromRGBO(255,215,0, 1);
      case 2:
        return const Color.fromRGBO(192,192,192, 1);
      case 3:
        return const Color.fromRGBO(196,156,72, 1);
      default:
        return Colors.pink;
    }
  }

}