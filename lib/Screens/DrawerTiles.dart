import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kiranas_web/Policies/Policies.dart';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiranas_web/SharedPref/UserDetailsSP.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProgressDialog progressDialogLogout;

class DrawerTiles extends StatelessWidget {
  DrawerTiles({this.icon, this.title});

  final Widget icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    progressDialogLogout = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialogLogout.style(
        message: "Please Wait...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);

    return ListTile(
        leading: icon,
        title: Text(title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            )),
        onTap: () async {
          if (title == "Logout") {
            progressDialogLogout.show().then((value) {
              if (value) {
                _signOut(context);
              }
            });
          } else if (title == "Payent Details") {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Payment Details'),
                    content: SizedBox(
                      height: 100,
                      child: Column(
                        children: [
                          Row(
                            children: [SelectableText("Phone No : 8369275230")],
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              SelectableText("UPI ID : 8369275230@ybl")
                            ],
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      // FlatButton(
                      //   child: Text('NO'),
                      //   onPressed: () {
                      //     Navigator.of(context).pop(false);
                      //   },
                      // ),
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          } else if (title == "About Us") {
            // Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'About Us',
                      textAlign: TextAlign.center,
                    ),
                    content: SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: SelectableText(
                                    "A B2B e-commerce app for local brick and mortar kirana shop."),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: SelectableText(
                                  "Made with :) by immo",
                                  style: TextStyle(fontSize: 10),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.pink[900]),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => WebViewContainer()));
          } else if (title == "Contact Us") {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Contact Us',
                      textAlign: TextAlign.center,
                    ),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        children: [
                          TableRow(children: [
                            Text(
                              "@Branded Baniya",
                              textAlign: TextAlign.center,
                            ),
                          ]),
                          TableRow(children: [
                            Text(
                              "",
                              textAlign: TextAlign.center,
                            ),
                          ]),
                          TableRow(children: [
                            Text(
                              "+91-8976399881",
                              textAlign: TextAlign.center,
                            )
                          ]),
                          TableRow(children: [
                            Text(
                              "+91-8369275230",
                              textAlign: TextAlign.center,
                            ),
                          ]),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.pink[900]),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => WebViewContainer()));
          } else if (title == 'Privacy Policy') {
            // Navigator.of(context).pop();
            _showPolicies("privacy", context);
          } else if (title == 'Terms & Conditions') {
            //  Navigator.of(context).pop();
            _showPolicies("Terms", context);
          } else if (title == 'Cancellation/Refund Policies') {
            // Navigator.of(context).pop();
            _showPolicies("Refund", context);
          }
        });
  }

  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    progressDialogLogout.hide().then((isHidden) {
      if (isHidden) {
        UserDetailsSP().logOutUser();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/Login',
          ModalRoute.withName('/Login'),
        );
      }
    });
  }

  _showPolicies(String action, BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (BuildContext context) {
          return Scrollbar(
            child: SingleChildScrollView(
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                return new Container(
                  // height: 500,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.85,
                        width: MediaQuery.of(context).size.height * 0.95,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Policies(
                              action: action,
                            ),
                          ),
                        ),
                      )
                      //  displayUpiApps(),
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }
}
