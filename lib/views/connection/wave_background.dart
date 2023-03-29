import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:shake/shake.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class WaveBackground extends StatefulWidget{
  final double defaultHeigth;
  final int numberOfSteps;
  final Function winGame;
  WaveBackground({super.key, this.defaultHeigth = 0.2, this.numberOfSteps = 10, required this.winGame});

  @override
  State<WaveBackground> createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground> with TickerProviderStateMixin{
  late ShakeDetector shakeDetector;

  bool isWaveLockedAtTop = false;
  bool isResetingWaveHeigth = false;

  late AnimationController waveWobblingController;

  late AnimationController waveHeightController = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
    lowerBound: widget.defaultHeigth,
    upperBound: widget.defaultHeigth + (1 - widget.defaultHeigth) / widget.numberOfSteps
  );

  final waveStopWatch = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );
  dynamic waveStopWatchTime;

  double velocity = 0;

  Timer shakeReset = Timer(Duration.zero, () { });


  double computeWobblingValue(double value) {
      double tmp = value < 0.5 ? 2 * value : (1 - value) * 2;

      return Curves.easeInOut.transform(tmp) * 30;
  }

  double computeHeightValue(double value, double lower, double upper, bool reverse) {
    double t = (value - lower) / (upper - lower);
    double res = lower + Curves.easeInOut.transform(t) * (upper - lower);
    return reverse ? 1 - res : res;
  }

  shakePhone() {
    
    shakeDetector.stopListening();

    if (shakeDetector.mShakeCount == 1){
      waveStopWatch.onStartTimer();
    }

    shakeReset.cancel();

    int animSpeed;
    
    if (velocity > 50){
      animSpeed = 150 - velocity.round();
    } else if (velocity > 40){
      animSpeed = 100;
    } else if (velocity > 30){
      animSpeed = 300;
    } else if (velocity > 15){
      animSpeed = 600;
    } else {
      animSpeed = 1000;
    }

    waveHeightController.duration = Duration(milliseconds: animSpeed);
    
    waveHeightController.forward().then((value) {
      if(shakeDetector.mShakeCount == widget.numberOfSteps + 1){
        waveStopWatch.onStopTimer();
        shakeDetector.stopListening();
        isWaveLockedAtTop = true;

        widget.winGame(waveStopWatch.rawTime.value);

      } else {
        waveHeightController = AnimationController(
          duration: const Duration(milliseconds: 600),
          vsync: this,
          lowerBound: waveHeightController.lowerBound + (1 - widget.defaultHeigth) / widget.numberOfSteps,
          upperBound: waveHeightController.upperBound + (1 - widget.defaultHeigth) / widget.numberOfSteps
        );
        shakeReset = Timer(const Duration(seconds: 2), (){
          resetWaveHeigth();
        });
        shakeDetector.startListening();
      }
    });
  }

  resetWaveHeigth(){
    isResetingWaveHeigth = true;
    waveStopWatch.onResetTimer();
    waveHeightController = AnimationController(
      duration: Duration(milliseconds: (200 * shakeDetector.mShakeCount).round()),
      vsync: this,
      lowerBound: 1 - waveHeightController.lowerBound,
      upperBound: 1 - widget.defaultHeigth
    );

    waveHeightController
      .forward()
      .then((_) { 
        isResetingWaveHeigth = false;
        waveHeightController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
      lowerBound: widget.defaultHeigth,
      upperBound: widget.defaultHeigth + (1 - widget.defaultHeigth)/ widget.numberOfSteps
    );
    });
  }

  saveScore(){

  }

  @override
  void initState() {
    super.initState();
    shakeDetector = ShakeDetector.autoStart(
    onPhoneShake: () {
          shakePhone();
        },
    shakeCountResetTime: 2000
    );

    waveWobblingController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )
    ..forward()
    ..addListener(() {
      if (waveWobblingController.isCompleted) {
        waveWobblingController.repeat();
      }
    });

    userAccelerometerEvents.listen((event) {
      double newVelocity = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if ((newVelocity - velocity).abs() < 1){
        return;
      }

      setState(() {
        velocity = newVelocity;
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    waveWobblingController.dispose();
    await waveStopWatch.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: Listenable.merge([waveWobblingController, waveHeightController]),
      builder: (context, child) => Transform.translate(
        offset: Offset(
          0,
          computeWobblingValue(waveWobblingController.value)
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
            [
              computeHeightValue(waveHeightController.value, waveHeightController.lowerBound, waveHeightController.upperBound, !isResetingWaveHeigth),
              computeHeightValue(waveHeightController.value, waveHeightController.lowerBound, waveHeightController.upperBound, !isResetingWaveHeigth) + 0.03,
              computeHeightValue(waveHeightController.value, waveHeightController.lowerBound, waveHeightController.upperBound, !isResetingWaveHeigth) + 0.06
            ]
        ),
        size: const Size(double.infinity, double.infinity),
        waveAmplitude: 10,
      ),
      )
    );
  }
}