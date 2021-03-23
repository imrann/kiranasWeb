import 'dart:convert';

import 'package:kiranas_web/Podo/Orders.dart';
import 'package:kiranas_web/Services/OrderService.dart';
import 'package:kiranas_web/SharedPref/UserDetailsSP.dart';
import 'package:kiranas_web/StateManager/CartState.dart';

// var formatter = DateFormat.Hms("dd-MM-yyyy");
// String formattedTodayDate = formatter.format(now);

class OrderController {
  Future<dynamic> getOrdersByType(String type) async {
    Map userDetails = await UserDetailsSP().getUserDetails();

    var ordersList =
        await OrderService().getOrdersByType(type, userDetails['userId']);

    return ordersList;
  }

  Future<dynamic> getPaginatedOrdersByType(
      String type, String lastOrderID, num lastOUpdateDate) async {
    Map userDetails = await UserDetailsSP().getUserDetails();

    var ordersList = await OrderService().getPaginatedOrdersByType(
        type, lastOrderID, lastOUpdateDate, userDetails['userId']);

    return ordersList;
  }

  Future<dynamic> updateOrderStatus(
      {String orderID, String status, String est}) async {
    var statusResult = await OrderService()
        .updateOrderStatus(orderID: orderID, status: status);

    return statusResult;
  }

  Future<dynamic> createOrder(CartState cartState, String paymentMode) async {
    var now = new DateTime.now().millisecondsSinceEpoch;
    Map userDetails = await UserDetailsSP().getUserDetails();

    OBillTotal obillTotal = OBillTotal(
        amt: cartState.getTotalMrp.toString(),
        offAmt: cartState.getTotalDiscount.toString(),
        totalAmt: cartState.getGrandTotal.toString());

    OUserAddress oUserAddress = OUserAddress(
        address: userDetails['userAddress']['address'],
        city: userDetails['userAddress']['city'],
        landmark: userDetails['userAddress']['landmark'],
        locality: userDetails['userAddress']['locality'],
        pincode: userDetails['userAddress']['pincode'],
        state: userDetails['userAddress']['state']);

    List<OProducts> listProducts = [];
    for (var cartItems in cartState.getSalesCartItems()) {
      OProducts pro = OProducts(
        createDate: cartItems['createDate'].toString(),
        discontinue: cartItems['discontinue'],
        productBrand: cartItems['productBrand'].toString(),
        productCategory: cartItems['productCategory'].toString(),
        productCp: cartItems['productCp'].toString(),
        productDescription: cartItems['productDescription'].toString(),
        productMrp: cartItems['productMrp'].toString(),
        productName: cartItems['productName'].toString(),
        productNetWeight: cartItems['productNetWeight'].toString(),
        productOffPercentage: cartItems['productOffPercentage'],
        productOffPrice: cartItems['productOffPrice'].toString(),
        productQty: cartItems['productQty'].toString(),
        productUnit: cartItems['productUnit'].toString(),
        productUrl: cartItems['productUrl'].toString(),
        updateDate: cartItems['updateDate'].toString(),
      );
      listProducts.add(pro);
    }

    Orders orders = Orders(
      oBillTotal: obillTotal,
      oDop: now,
      oEstDelivaryTime: "Waiting for order acceptance",
      oProducts: listProducts,
      oStatus: "Open",
      oTrackingStatus: "Placed",
      oUserAddress: oUserAddress,
      oUserID: userDetails['userId'],
      oUserName: userDetails['userName'],
      oUserPhone: userDetails['userPhone'],
      oUpdateDate: now,
    );

    var orderDetails = json.encode(orders);
    var isOrderCreated =
        await OrderService().createOrder(orderDetails, paymentMode);

    return isOrderCreated;
  }

  Future<dynamic> getOrderByFilterByUserID(
      {String dop,
      String dod,
      String doc,
      String trackingStatus,
      String status}) async {
    Map userDetails = await UserDetailsSP().getUserDetails();

    var productFilteredSearchList;
    if (dop == null && dod == null && doc == null && trackingStatus == null) {
      print("ALL NULLLLLLLLLLLL");
      productFilteredSearchList =
          await OrderService().getOrdersByType(status, userDetails['userId']);
    } else {
      productFilteredSearchList = await OrderService().getOrderByFilterByUserID(
          dop: dop,
          dod: dod,
          doc: doc,
          status: status,
          trackingStatus: trackingStatus,
          userId: userDetails['userId']);
    }

    return productFilteredSearchList;
  }
}
