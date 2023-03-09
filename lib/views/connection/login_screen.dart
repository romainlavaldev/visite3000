import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:visite3000/views/connection/sign_up.dart';
import 'package:visite3000/views/connection/sign_up_form_part.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'login_form_part.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin{

  late AnimationController waveHeigthController;

  @override
  void initState() {
    super.initState();

    waveHeigthController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )
    ..forward()
    ..addListener(() {
      if (waveHeigthController.isCompleted) {
        waveHeigthController.repeat();
      }
    });
    
  }

  double shake(double value) {
      double tmp = value < 0.5 ? 2 * value : (1 - value) * 2;

      return Curves.easeInOut.transform(tmp);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    waveHeigthController.dispose();
  }

  bool _isLoading = false;
  bool isLoginForm = true;

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
          AnimatedBuilder(
            animation: waveHeigthController,
            builder: (context, child) => Transform.translate(
              offset: Offset(
                0,
                shake(waveHeigthController.value) * 100
              ),
              child: WaveWidget(
              config: CustomConfig(
                colors: [
                  Colors.yellow.withOpacity(0.3),
                  Colors.yellow.withOpacity(0.5),
                  Colors.yellow.withOpacity(0.8),
                ],
                durations: [
                  15000,
                  12000,
                  10000,
                ],
                heightPercentages: [
                  0.70,
                  0.73,
                  0.75,
                ]
              ),
              size: const Size(double.maxFinite, double.maxFinite),
              waveAmplitude: 5,
            ),
            )
          ),
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
                        Widget formContent = isLoginForm ? LoginFormPart(setIsLoading: setIsLoading) : const SignUpFormPart();
                    
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
        ],
      )
    );
  }
}