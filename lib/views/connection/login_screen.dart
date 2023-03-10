import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shake/shake.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
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

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{

  late AnimationController waveHeigthController;

  late AnimationController waveShakeFluidHeigth = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
      lowerBound: 0.6,
      upperBound: 0.7
    );

  late ShakeDetector shakeDetector;

  bool isWaveLockedAtTop = false;

  bool _isLoading = false;
  bool isLoginForm = true;
  bool isResetingWaveHeigth = false;

  dynamic waveStopWatchTime;

  final waveStopWatch = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );


  @override
  void initState() {
    super.initState();

    shakeDetector = ShakeDetector.autoStart(
    onPhoneShake: () {
          shakePhone();
        },
    );

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

  double heigthCompute(double value, lower, upper) {
    return ((upper + lower) / 2 - value) + (upper + lower) / 2;
  }

  Timer shakeReset = Timer(Duration.zero, () { });
  shakePhone(){

    if (shakeDetector.mShakeCount == 1){
      waveStopWatch.onStartTimer();
    }

    shakeReset.cancel();

    waveShakeFluidHeigth.forward().then((value) {
      waveShakeFluidHeigth = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
        lowerBound: waveShakeFluidHeigth.lowerBound - 0.1,
        upperBound: waveShakeFluidHeigth.upperBound - 0.1
      );

      if(waveShakeFluidHeigth.value <= -0.2){

        waveStopWatch.onStopTimer();
        shakeDetector.stopListening();
        isWaveLockedAtTop = true;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              elevation: 0,
              content: Text(
                "C'EST GAGNE, TEMPS : ${StopWatchTimer.getDisplayTime(waveStopWatch.rawTime.value)}",
                textAlign: TextAlign.center,
              ),
              icon: const Icon(Icons.person_off_outlined),
            )
          );
      } else {
        shakeReset = Timer(const Duration(seconds: 2), (){
          resetWaveHeigth();
        });
      }
    });
    
  }

  resetWaveHeigth(){
    isResetingWaveHeigth = true;
    waveShakeFluidHeigth = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
      lowerBound: waveShakeFluidHeigth.upperBound,
      upperBound: 0.7
    );
    waveShakeFluidHeigth
      .forward()
      .then((_) { 
        isResetingWaveHeigth = false;
        waveShakeFluidHeigth = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
      lowerBound: 0.6,
      upperBound: 0.7
    );
    });
  }

  @override
  void dispose() async {
    super.dispose();
    waveHeigthController.dispose();
    await waveStopWatch.dispose();
  }


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
            animation: Listenable.merge([waveHeigthController, waveShakeFluidHeigth]),
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
                heightPercentages: 
                  isResetingWaveHeigth ?
                  [
                    waveShakeFluidHeigth.value,
                    waveShakeFluidHeigth.value + 0.03,
                    waveShakeFluidHeigth.value + 0.06
                  ]
                   : 
                  [
                    heigthCompute(waveShakeFluidHeigth.value, waveShakeFluidHeigth.upperBound, waveShakeFluidHeigth.lowerBound),
                    heigthCompute(waveShakeFluidHeigth.value, waveShakeFluidHeigth.upperBound, waveShakeFluidHeigth.lowerBound) + 0.03,
                    heigthCompute(waveShakeFluidHeigth.value, waveShakeFluidHeigth.upperBound, waveShakeFluidHeigth.lowerBound) + 0.06
                  ]
              ),
              size: const Size(double.infinity, double.infinity),
              waveAmplitude: 10,
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