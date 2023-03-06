import 'package:flutter/material.dart';
import 'package:visite3000/main.dart';

class NoInternet extends StatelessWidget{
  const NoInternet({super.key});

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
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Column(
                      children: [
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
            ),
          ),
        ],
      ),
    );
  }
}