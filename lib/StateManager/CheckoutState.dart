import 'package:flutter/material.dart';

class CheckoutState extends ChangeNotifier {
  bool isAddressP;
  bool getIsAddressP() => isAddressP;

  setIsAddressP(bool isAddressP) {
    this.isAddressP = isAddressP;
    notifyListeners();
  }

  String buttonAction = "NA";

  String getButtonAction() => buttonAction;

  setButtonAction(String buttonAction) {
    this.buttonAction = buttonAction;
    notifyListeners();
  }

  String userDetails;
  String getUserDetails() => userDetails;

  setUserDetails(String userDetails) {
    this.userDetails = userDetails;
    notifyListeners();
  }
}
