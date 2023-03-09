import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:visite3000/views/common/no_internet.dart';

import 'package:visite3000/globals.dart' as globals;

import '../../layout.dart';

class LoginFormPart extends StatefulWidget{
  final Function setIsLoading;
  const LoginFormPart({super.key, required this.setIsLoading});
  
  @override
  State<LoginFormPart> createState() => _LoginFormPartState();
}

class _LoginFormPartState extends State<LoginFormPart>{
  final _loginfromkey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  final _storage = const FlutterSecureStorage();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _tryLogin() async {

    widget.setIsLoading(true);
    
    Map data = {'username': usernameController.text, 'password': passwordController.text};

    String body = jsonEncode(data);

   await Future.delayed(const Duration(seconds: 2), (){});

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
        widget.setIsLoading(false);

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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
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
      );
  }
}