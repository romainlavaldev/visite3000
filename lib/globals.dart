library visite3000.globals;

import 'package:flutter/cupertino.dart';

String serverEntryPoint = "http://rlaval-dev.fr:81";

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}