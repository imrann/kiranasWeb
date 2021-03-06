import 'package:flutter/material.dart';
import 'package:kiranas_web/Screens/Login.dart';
import 'package:kiranas_web/Screens/Home.dart';
import 'package:kiranas_web/Screens/Orders.dart';
import 'package:kiranas_web/Screens/ProductDetails.dart';
import 'package:kiranas_web/Screens/Maintainance.dart';
import 'package:kiranas_web/Screens/Cart.dart';
import 'package:kiranas_web/Screens/CheckOut.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // final args = settings.arguments;

    switch (settings.name) {
      case '/Login':
        return MaterialPageRoute(builder: (cotext) => Login());

      case '/Home':
        final Home args = settings.arguments;

        return MaterialPageRoute(
          builder: (cotext) => Home(
            phone: args.phone,
            user: args.user,
            userID: args.userID,
          ),
        );

      case '/Orders':
        final Orders args = settings.arguments;

        return MaterialPageRoute(
          builder: (cotext) => Orders(initialTabIndex: args.initialTabIndex),
        );
      case '/Cart':
        return MaterialPageRoute(
          builder: (cotext) => Cart(),
        );

      case '/Maintainance':
        return MaterialPageRoute(
          builder: (cotext) => Maintainance(),
        );
      case '/CheckOut':
        return MaterialPageRoute(
          builder: (cotext) => CheckOut(),
        );
      case '/ProductDetails':
        final ProductDetails args = settings.arguments;

        return MaterialPageRoute(
          builder: (cotext) => ProductDetails(
              heroIndex: args.heroIndex, productDetails: args.productDetails),
        );

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
