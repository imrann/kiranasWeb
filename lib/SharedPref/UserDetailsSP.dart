import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsSP {
  Future<dynamic> loginUser(String userDetailsForPref) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("uDetails", userDetailsForPref);
    preferences.setString("deviceToken", "empty");

    return true;
  }

  Future<dynamic> setIsAddressPresent(bool isAddressPresent) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setBool("isAddressPresent", isAddressPresent);

    return true;
  }

  Future<bool> isAddressPresent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    bool isAddressPresent = preferences.getBool("isAddressPresent");

    return isAddressPresent;
  }

  // Future<String> getDeviceToken() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();

  //   String token = preferences.getString("deviceToken");

  //   return token;
  // }

  // Future<String> setDeviceToken(String token) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();

  //   preferences.setString("deviceToken", token);

  //   return token;
  // }

  Future<dynamic> logOutUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // var user = jsonEncode(userDetails);

    preferences.remove("uDetails");
  }

  Future<String> getDeviceToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String token = preferences.getString("deviceToken");

    return token;
  }

  Future<String> setDeviceToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("deviceToken", token);

    return token;
  }

  Future<Map> getUserDetails() async {
    // String role = 'User';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> userD = new Map<String, dynamic>();
    String userDetails = preferences.getString("uDetails");
    if (userDetails != null) {
      userD = json.decode(userDetails);
    }

    return userD;
  }

  Future<dynamic> updateAddress(Map<String, dynamic> address) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> userD = new Map<String, dynamic>();
    String userDetails = preferences.getString("uDetails");
    if (userDetails != null) {
      userD = json.decode(userDetails);
    }
    userD.addAll({"userAddress": address});
    String updatUserDetails = json.encode(userD);
    preferences.setString("uDetails", updatUserDetails);

    return userD;
  }

  Future<String> getPrevSavedState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String orderPageState = preferences.getString("orderPageState");
    return orderPageState;
  }

  Future<Map> setPrevSavedState(String orderPageState) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("orderPageState", orderPageState);
  }
}
