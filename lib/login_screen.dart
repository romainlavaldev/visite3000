import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  final _loginfromkey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  void _tryLogin() async {

    Map data = {'username': usernameController.text, 'password': passwordController.text};

    String body = jsonEncode(data);
    Response response = await http.post(
      Uri.parse('http://localhost/visite3000/login.php'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    );

    if (response.statusCode == 200)
    {
      dynamic jsonData = json.decode(response.body);
      if (jsonData['status'] == true)
      {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text("Log OK"),
              ));
      }
      else
      {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text("Log KO"),
              ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.pink,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 100,
              right: 60,
              left: 60,
              bottom: 30
            ),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Visite3000",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                            ),
                          ),
                          Form(
                            key: _loginfromkey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: usernameController,
                                  decoration: const InputDecoration(
                                    hintText: "Username"
                                  ),
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: const InputDecoration(
                                    hintText: "Password"
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: _tryLogin,
                            child: const Text("Login"),
                          )
                        ],
                      ),
                    )
                  ),
                )
              ],
            ),
          )
        ]
      ),
    );
  }

}