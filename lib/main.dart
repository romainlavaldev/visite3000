import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';  
import 'package:visite3000/layout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:visite3000/views/connection/login_screen.dart';

import 'globals.dart' as globals;

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}



class MyApp extends StatefulWidget{

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}



class _MyApp extends State<MyApp> {
  final _storage = const FlutterSecureStorage();

  late Future<Widget> _firstPage;

  Future<Widget> _getPageFromTokenValue() async {

    String? storedToken = await _storage.read(key: "Token");

    if (storedToken == null){
      //Not logged in
      _storage.deleteAll();
      return const LoginScreen();
    }
    else{
      //Checking token
      Map data = {'userId': await _storage.read(key: "UserId"), 'token': storedToken};

      String body = jsonEncode(data);
      Response response = await http.post(
        Uri.parse('${globals.serverEntryPoint}/db/check_token.php'),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*'
        }
      );

      if (response.statusCode == 200){
        dynamic jsonData = json.decode(response.body);
        if (jsonData['status'] == 1){
          //Token is correct
          return const Layout();
        } else {
          //Token is incorrect
          _storage.deleteAll();
          return const LoginScreen();
        }
      }
    }
    return const LoginScreen();
  }

  @override
  void initState() {
    super.initState();
    _firstPage = _getPageFromTokenValue();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Visite3000',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
      ),
      home: FutureBuilder(
        future: _firstPage,
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            return snapshot.data as Widget;
          }
          else
          {
            return Scaffold(
              backgroundColor: Colors.pink,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SpinKitCubeGrid(
                      color: Colors.white,
                      size: 60,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Loading...",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            );              
          }
        },
      ),
    );
  }
}