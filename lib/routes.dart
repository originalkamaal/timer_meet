import 'package:flutter/material.dart';
import 'package:timer_meet/screens/active_meeting.dart';
import 'package:timer_meet/screens/error_screen.dart';
import 'package:timer_meet/screens/home_screen.dart';
import 'package:timer_meet/screens/login_screen.dart';

class MyRoutes {
  static Route onGeneratedRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return routeBuilder(const LoginScreen());
      case "/home":
        return routeBuilder(const HomeScreen());
      case "/activeMeeting":
        var args = (settings.arguments as String);
        return routeBuilder(ActiveMeeting(referance: args));

      default:
        return routeBuilder(const ErrorScreen());
    }
  }

  static MaterialPageRoute<dynamic> routeBuilder(Widget widget) =>
      MaterialPageRoute(builder: (_) => widget);
}
