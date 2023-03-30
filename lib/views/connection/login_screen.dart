import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:visite3000/views/connection/scoreboard.dart';
import 'package:visite3000/views/connection/sign_up_form_part.dart';
import 'package:visite3000/views/connection/wave_background.dart';

import 'package:visite3000/globals.dart' as globals;
import '../common/no_internet.dart';
import 'login_form_part.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  bool _isLoading = false;
  bool isLoginForm = true;
  bool isGameWon = false;
  bool isGameScoreSaved = false;
  late int gameTime;
  TextEditingController gameNameController = TextEditingController();

  setIsRegistered(bool isRegistered){
    setState(() {
      isLoginForm = isRegistered;
    });
  }

  setIsLoading(bool isLoading){
    setState(() {
      _isLoading = isLoading;
    });
  }

  winGame(int time){
    setState(() {
      isGameWon = true;
      gameTime = time;
    });
  }


  saveScore(){
    return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Save score'),
        content: TextField(
          controller: gameNameController,
          decoration: const InputDecoration(hintText: "Your name"),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.pink,
              fixedSize: const Size(120, 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))
              )
            ),
            child: const Text('Save'),
            onPressed: () {
              setState(() {
                sendScoreToDatabase();
                isGameScoreSaved = true;
                
                Navigator.pop(context);
              });
            },
          ),
        ],
      );
    });
  }

  sendScoreToDatabase() async {
    Map data = {'name': gameNameController.text, 'time': gameTime, 'displayTime': StopWatchTimer.getDisplayTime(gameTime)};

    String body = jsonEncode(data);
    await Future.delayed(const Duration(seconds: 2), (){});

      try{
        await http.post(
          Uri.parse('${globals.serverEntryPoint}/db/save_game_score.php'),
          body: body,
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
          }
        );
      } catch(e) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const NoInternet()));
        return;
      }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.pink,
      body: Stack(
        alignment: Alignment.center,
        children: [
          WaveBackground(numberOfSteps: 15, winGame: winGame,),
          Padding(
            padding: const EdgeInsets.only(
              top: 100,
              right: 20,
              left: 20,
              bottom: 100
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Visite3000",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: "Reality Hyper"
                  ),
                ),
                Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      child: (() {
                        Widget formContent = isLoginForm ? LoginFormPart(setIsLoading: setIsLoading) : SignUpFormPart(setIsRegistered: setIsRegistered, setIsLoading: setIsLoading);
                    
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          
                          child: formContent,
                        );
                      } ()),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      
                      children: [
                        Text(
                          isLoginForm ? "No account ? " : "Have an account ? ",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            isLoginForm = !isLoginForm;
                          }),
                          child: Text(
                            isLoginForm ? "Sign up" : "Sign in",
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 16,
                              fontWeight: FontWeight.w900
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                  const SizedBox()
              ],
            ),
          ),
          if (_isLoading) BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 2,
              sigmaY: 2
            ),
            child: Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(
                child: SpinKitCubeGrid(
                  color: Colors.pink,
                  size: 60,
                ),
              ),
            ),
          ),
          if (isGameWon && !isGameScoreSaved) Container(
            decoration: const BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Text(
                        "You won the game !",
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white
                        ),
                      ),
                      Text(
                        " Your time is",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                  Text(
                    StopWatchTimer.getDisplayTime(gameTime),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.pink,
                      backgroundColor: Colors.white,
                      fixedSize: const Size(120, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))
                      )
                    ),
                    onPressed: saveScore,
                    child: const Text(
                      "Save score !"
                    )
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryanim) => const ScoreBoard(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return Align(
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                  )
                );
              },
              child: const Text("Scoreboard"),
            ),
          )
        ],
      )
    );
  }
}