import 'package:flutter/material.dart';

import 'package:nibav/presentation/screens/splash_screen.dart';
import 'package:nibav/presentation/screens/home_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case '/splash':
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      default:
        return null;
    }
  }
}