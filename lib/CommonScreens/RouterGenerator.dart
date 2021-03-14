import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kiranas_web/Screens/Login.dart';
import 'package:kiranas_web/Screens/Home.dart';
import 'package:kiranas_web/Screens/Orders.dart';
import 'package:kiranas_web/Screens/ProductDetails.dart';
import 'package:kiranas_web/Screens/Maintainance.dart';
import 'package:kiranas_web/Screens/Cart.dart';
import 'package:kiranas_web/Screens/CheckOut.dart';

import '../main.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // final args = settings.arguments;

    switch (settings.name) {
      case '/Home':
        {
          final Home args = settings.arguments;
          MaterialPageRoute<dynamic> pageRoute;

          if (isUserLoggedIn && args != null) {
            pageRoute = MaterialPageRoute(
              settings: settings,
              builder: (_) => Home(
                phone: args.phone,
                user: args.user,
                userID: args.userID,
              ),
            );
          } else if (isUserLoggedIn && args == null) {
            pageRoute = _unAuthRoute();
          } else {
            userLoggedOutToast();
            SystemNavigator.routeUpdated(
                routeName: '/Login', previousRouteName: null);
            pageRoute = MaterialPageRoute(builder: (_) => Login());
          }
          return pageRoute;
        }
      case '/Login':
        {
          return MaterialPageRoute(settings: settings, builder: (_) => Login());
          // MaterialPageRoute<dynamic> pageRoute;
          // if (!isUserLoggedIn) {
          //   pageRoute =
          //       MaterialPageRoute(settings: settings, builder: (_) => Login());
          // } else {
          //   pageRoute = MaterialPageRoute(builder: (_) {
          //     return Scaffold(
          //       appBar: AppBar(
          //         title: Text('Already Logged In'),
          //       ),
          //       body: Center(
          //         child: Text('Please Logout first'),
          //       ),
          //     );
          //   });
          // }
          // return pageRoute;
        }

      // case '/':
      //   final Home args = settings.arguments;

      //   return MaterialPageRoute(
      //     builder: (_) => Home(
      //       phone: args.phone,
      //       user: args.user,
      //       userID: args.userID,
      //     ),
      //   );
      case '/Orders':
        {
          final Orders args = settings.arguments;
          print(args.toString());
          MaterialPageRoute<dynamic> pageRoute;

          if (isUserLoggedIn && args != null) {
            pageRoute = MaterialPageRoute(
              settings: settings,
              builder: (_) => Orders(initialTabIndex: args.initialTabIndex),
            );
          } else if (isUserLoggedIn && args == null) {
            pageRoute = _unAuthRoute();
          } else {
            userLoggedOutToast();
            SystemNavigator.routeUpdated(
                routeName: '/Login', previousRouteName: null);
            pageRoute = MaterialPageRoute(builder: (_) => Login());
          }
          return pageRoute;
        }
      case '/Cart':
        MaterialPageRoute<dynamic> pageRoute;

        if (isUserLoggedIn) {
          pageRoute = MaterialPageRoute(
            settings: settings,
            builder: (_) => Cart(),
          );
        } else {
          userLoggedOutToast();
          SystemNavigator.routeUpdated(
              routeName: '/Login', previousRouteName: null);
          pageRoute = MaterialPageRoute(builder: (_) => Login());
        }
        return pageRoute;

      case '/Maintainance':
        MaterialPageRoute<dynamic> pageRoute;

        if (isUserLoggedIn) {
          pageRoute = MaterialPageRoute(
            settings: settings,
            builder: (_) => Maintainance(),
          );
        } else {
          userLoggedOutToast();
          SystemNavigator.routeUpdated(
              routeName: '/Login', previousRouteName: null);
          pageRoute = MaterialPageRoute(builder: (_) => Login());
        }
        return pageRoute;

      case '/CheckOut':
        MaterialPageRoute<dynamic> pageRoute;

        if (isUserLoggedIn) {
          pageRoute = MaterialPageRoute(
            settings: settings,
            builder: (_) => CheckOut(),
          );
        } else {
          userLoggedOutToast();
          SystemNavigator.routeUpdated(
              routeName: '/Login', previousRouteName: null);
          pageRoute = MaterialPageRoute(builder: (_) => Login());
        }
        return pageRoute;

      case '/ProductDetails':
        final ProductDetails args = settings.arguments;

        MaterialPageRoute<dynamic> pageRoute;

        if (isUserLoggedIn && args != null) {
          pageRoute = MaterialPageRoute(
            settings: settings,
            builder: (_) => ProductDetails(
                heroIndex: args.heroIndex, productDetails: args.productDetails),
          );
        } else if (isUserLoggedIn && args == null) {
          pageRoute = _unAuthRoute();
        } else {
          userLoggedOutToast();
          SystemNavigator.routeUpdated(
              routeName: '/Login', previousRouteName: null);
          pageRoute = MaterialPageRoute(builder: (_) => Login());
        }
        return pageRoute;

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
          child: Text('Unknown Route'),
        ),
      );
    });
  }

  static Route<dynamic> _unAuthRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Unautorize'),
        ),
        body: Center(
          child: Text('Unauthorize path, cannot navigate through url'),
        ),
      );
    });
  }
}

userLoggedOutToast() {
  Fluttertoast.showToast(
    gravity: ToastGravity.CENTER,
    msg: "Please login first !",
    fontSize: 20,
    backgroundColor: Colors.black,
  );
}
