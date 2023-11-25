import 'package:flutter/material.dart';

import '../../src/home/view/product_details.dart';
import '../../src/main_screen/view/main_screen.dart';
import '../../src/notification_screen/view/notification_screen.dart';

class RouteGenrator {
  Map<String, dynamic> routs;
  RouteGenrator({
    required this.routs,
  });
  static Route<dynamic> genratedRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case MainScreen.routeName:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case ProductDetailsScreen.routeName:
        final args = settings.arguments as Map;

        return MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(
                  productData: args['productData'],
                  addToCart: args['addToCart'],
                  addToFav: args['addToFav'],
                  fromFav: args['fromFav'] ?? false,
                ));
      case NotificationScreen.routeName:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());

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
