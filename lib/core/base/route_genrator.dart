import 'package:flutter/material.dart';

import '../../src/main_screen/view/main_screen.dart';
import '../../src/select_employee/view/select_the_employee_screen.dart';

class RouteGenerator {
  Map<String, dynamic> routs;
  RouteGenerator({
    required this.routs,
  });
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainScreen.routeName:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => MainScreen(
                  selectedIndex: args['selectedIndex'],
                ));
      case SelectTheEmployeeScreen.routeName:
        return MaterialPageRoute(builder: (_) => SelectTheEmployeeScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
