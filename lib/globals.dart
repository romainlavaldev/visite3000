library visite3000.globals;

import 'package:flutter/cupertino.dart';

String serverEntryPoint = "http://192.168.51.70/visite3000";

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}