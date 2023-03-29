library visite3000.globals;

import 'package:flutter/cupertino.dart';

String serverEntryPoint = "http://192.168.1.89:81";

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}