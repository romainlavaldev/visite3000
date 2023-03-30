import 'package:flutter/material.dart';
import 'package:visite3000/main.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class NoInternet extends StatefulWidget{
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> with SingleTickerProviderStateMixin{

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
    waveHeigthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            height: double.maxFinite,
            child: const Align(
              alignment: Alignment.topCenter,
              child: Image(
                image: AssetImage("assets/no_internet_background.png"),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 350,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(400, 200),
                  topRight: Radius.elliptical(400, 200),
                )
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  WaveWidget(
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
                        0.60,
                        0.65,
                        0.70,
                      ]
                    ),
                    size: const Size(double.maxFinite, double.maxFinite),
                    waveAmplitude: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: const [
                            Text(
                              "Oops ! No internet connection",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "It seems that your phone can't connect to our servers !",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: const Size.fromWidth(150),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30))
                            )
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const MyApp()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(
                              top: 3,
                              bottom: 3
                            ),
                            child: Text(
                              "Retry",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}