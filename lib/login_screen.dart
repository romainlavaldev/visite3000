import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:visite3000/layout.dart';
import 'package:visite3000/sign_up.dart';
import 'package:visite3000/views/common/no_internet.dart';

import 'globals.dart' as globals;

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  final _storage = const FlutterSecureStorage();

  final _loginfromkey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _tryLogin() async {

    setState(() {
      _isLoading = true;
    });
    
    Map data = {'username': usernameController.text, 'password': passwordController.text};

    String body = jsonEncode(data);

    Response response;
    try{
       response = await http.post(
        Uri.parse('${globals.serverEntryPoint}/db/login.php'),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*'
        }
      );
    } catch(e){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const NoInternet()));
      return;
    }

    if (response.statusCode == 200)
    {
      dynamic jsonData = json.decode(response.body);
      if (jsonData['status'] == 1)
      {
        _storage.write(key: "Token", value: jsonData['datas']['token']);
        _storage.write(key: "UserId", value: jsonData['datas']['id']);

        Future((){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Layout()
            )
          );
        });
      }
      else
      {
        setState(() {
          _isLoading = false;
        });

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              elevation: 0,
              content: Text(
                jsonData['message'],
                textAlign: TextAlign.center,
              ),
              icon: const Icon(Icons.person_off_outlined),
            )
          );
      }
    }
  }

  _signUp(){
    Navigator.push(context, MaterialPageRoute(builder: (builder) => const SignUp()));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.pink,
      body: Stack(
        children: [
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
                    fontSize: 40
                  ),
                ),
                Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                          right: 40,
                          top: 50,
                          bottom: 20
                        ),
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
                            const SizedBox(
                              height: 40,
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: passwordController,
                                    obscureText: !_isPasswordVisible,
                                    keyboardType: TextInputType.visiblePassword,
                                    onEditingComplete: _tryLogin,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined
                                        ),
                                        color: Colors.pink,
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible = !_isPasswordVisible;
                                          });
                                        },
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            TextButton(
                              onPressed: _tryLogin,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.pink,
                                fixedSize: const Size(120, 50),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30))
                                )
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Login"),
                                  Icon(Icons.arrow_right_alt_rounded)
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                          )
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "No account ? ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16
                            ),
                          ),
                          GestureDetector(
                            onTap: _signUp,
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
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
              child: const SpinKitSpinningLines(
                itemCount: 5,
                color: Colors.pink,
                size: 60,
              ),
            ),
          ),
        ],
      )
    );
  }

}