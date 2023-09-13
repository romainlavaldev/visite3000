library visite3000.globals;

import 'package:flutter/cupertino.dart';

String serverEntryPoint = "http://visite.utema.fr";

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
