import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:visite3000/layout.dart';
import 'package:visite3000/login_form_part.dart';
import 'package:visite3000/sign_up.dart';
import 'package:visite3000/views/common/no_internet.dart';

import 'globals.dart' as globals;

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  bool _isLoading = false;

  _signUp(){
    Navigator.push(context, MaterialPageRoute(builder: (builder) => const SignUp()));
  }

  setIsLoading(bool isLoading){
    setState(() {
      _isLoading = isLoading;
    });
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
                      child: LoginFormPart(setIsLoading: setIsLoading)
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
              child: const Center(
                child: SpinKitCubeGrid(
                  color: Colors.pink,
                  size: 60,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

}