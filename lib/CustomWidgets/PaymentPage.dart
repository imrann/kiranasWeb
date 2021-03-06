import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kiranas_web/Controllers/OrderController.dart';
import 'package:kiranas_web/CustomWidgets/LIne.dart';
import 'package:kiranas_web/Screens/Orders.dart';
import 'package:kiranas_web/StateManager/CartState.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

// var formatter = DateFormat("dd-MM-yyyy");
// String formattedTodayDate = formatter.format(now);

class Payment extends StatefulWidget {
  final TabController tabController;
  Payment({this.tabController});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  ProgressDialog progressDialog;

  String paymentMode = "NA";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
        message: "Placing Order...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: scaffoldKey,
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                color: Colors.transparent,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Container(
                            height: 10,
                            width: 10,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                            height: 3,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Container(
                              color: Colors.grey[400],
                              child: Line(),
                            )),
                        getEndPoint()
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Address",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                        Text("Payment",
                            style: TextStyle(fontSize: 12, color: Colors.black))
                      ],
                    )
                  ],
                )),
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: ListTile(
                        title: const Text('Cash On Delivery'),
                        leading: Radio(
                          value: "COD",
                          activeColor: Colors.pink[900],
                          groupValue: paymentMode,
                          onChanged: (String value) {
                            setState(() {
                              paymentMode = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                                "Only COD is acceptable currently! UPI payment mode will be introduced in near future, Thanks.",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                          ),
                        )),
                  ],
                ),
                Row(
                  children: [
                    FlatButton(
                        onPressed: () {
                          widget.tabController
                              .animateTo(widget.tabController.index++);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back,
                              size: 15,
                              color: Colors.grey[400],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("ADDRESS",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey[400])),
                            )
                          ],
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width * 0.6,
            height: 45,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                splashColor: Colors.white,
                onPressed: () {
                  print(paymentMode);
                  if (paymentMode == "NA") {
                    Fluttertoast.showToast(
                        msg: "Please select a payment mode!",
                        fontSize: 13,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.black);
                  } else if (paymentMode == "COD") {
                    placeOrder();
                  }
                },
                color: Colors.pink[900],
                child: Text("PLACE ORDER",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  placeOrder() {
    progressDialog.show().then((isShown) {
      if (isShown) {
        var cartState = Provider.of<CartState>(context, listen: false);
        CartState cart = cartState;

        OrderController().createOrder(cart, paymentMode).then((value) {
          if (value == "orderCreated") {
            progressDialog.hide();
            cartState.clearSalesCartItems();
            orderConfirmationPopup(context, "PLACED");
          }
        }).catchError((err) {
          progressDialog.hide();
          print("error :" + err.toString());
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "$err",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 5),
          ));
        });
      }
    });
  }

  orderConfirmationPopup(BuildContext context, String action) {
    Widget buttons = Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: Text('CONTINUE',
                      style: TextStyle(color: Colors.grey[400])),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/Home',
                      ModalRoute.withName('/Home'),
                    );
                    // Navigator.pushReplacement(
                    //     context,
                    //     new MaterialPageRoute(
                    //       builder: (BuildContext context) => new Home(),
                    //     ));
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: Text('GO TO ORDERS',
                      style: TextStyle(color: Colors.grey[400])),
                  onPressed: () {
                    // Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/Orders',
                      ModalRoute.withName('/Home'),
                      arguments: Orders(initialTabIndex: "0"),
                    );
                    // Navigator.pushReplacement(
                    //     context,
                    //     new MaterialPageRoute(
                    //       builder: (BuildContext context) => new Orders(
                    //         initialTabIndex: "0",
                    //       ),
                    //     ));
                    // Navigator.of(context).pop();
                  },
                )
              ],
            )
          ],
        ));
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Container(
        height: 200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  size: 150,
                  color: Colors.green,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ORDER  " + action,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(action,
            //         style: TextStyle(fontSize: 20, color: Colors.green))
            //   ],
            // )
          ],
        ),
      ),
      actions: [buttons],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(onWillPop: () async => false, child: alert);
      },
    );
  }

  Widget getEndPoint() {
    return FutureBuilder<dynamic>(
        future: Future.delayed(Duration(milliseconds: 700), () {
          return Text("s");
        }),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Container(
                height: 10,
                width: 10,
                color: Colors.green,
              ),
            );
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Container(
                height: 10,
                width: 10,
                color: Colors.grey[400],
              ),
            );
          }
        });
  }
}
