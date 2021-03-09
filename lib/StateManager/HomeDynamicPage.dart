import 'package:flutter/material.dart';
import 'package:kiranas_web/Podo/Product.dart';

class HomeDynamicPageState extends ChangeNotifier {
  String activeHomePage = "home";

  String getActiveHomePage() => activeHomePage;

  setActiveHomePage(String activeHomePage) {
    this.activeHomePage = activeHomePage;
    notifyListeners();
  }

  ///////////////////////////////////////////
  Product productDetails = new Product();
  Product getProductDetails() => productDetails;

  setProductDetails(Product productDetails) {
    this.productDetails = productDetails;
    notifyListeners();
  }
}
