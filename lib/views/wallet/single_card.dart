import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:visite3000/globals.dart' as globals;



class SingleCard extends StatefulWidget{
  final int _cardId;
  const SingleCard(this._cardId, {super.key});

  @override
  State<SingleCard> createState() => _SingleCardState();
}

class _SingleCardState extends State<SingleCard> {
  bool isSelected = false;
  double angle = 0;

  Image? cardImage;

  void flipCard(){
    setState(() {
      isSelected = !isSelected;
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  void initState() {
    super.initState();
    cardImage = Image(image: NetworkImage("${globals.serverEntryPoint}/cards/${widget._cardId}.png"));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flipCard,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: angle),
        duration: const Duration(milliseconds: 600),
        builder: (BuildContext context, double val, __){
          return Transform(
            transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(val),
            alignment: Alignment.center,
            child: isSelected ?
              Stack(
                alignment: Alignment.center,
                fit: StackFit.passthrough,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: 2,
                        sigmaY: 2,
                        tileMode: TileMode.mirror
                      ),
                      child: cardImage
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle
                        ),
                        child: IconButton(
                          padding: const EdgeInsets.all(15),
                          iconSize: 40,
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.white
                          ),
                          onPressed: () => true,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle
                        ),
                        child: IconButton(
                          padding: const EdgeInsets.all(15),
                          iconSize: 40,
                          icon: const Icon(
                            Icons.mail,
                            color: Colors.white
                          ),
                          onPressed: () => true,
                        ),
                      ),Container(
                        decoration: const BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle
                        ),
                        child: IconButton(
                          padding: const EdgeInsets.all(15),
                          iconSize: 40,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white
                          ),
                          onPressed: () => true,
                        ),
                      ),
                    ],
                  )
                ],
              )
                :
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: cardImage
            ),
          );
        }
      )
    );
  }
}