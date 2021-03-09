import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranas_web/Controllers/LoginController.dart';
import 'package:kiranas_web/CustomWidgets/LIne.dart';
import 'package:kiranas_web/SharedPref/UserDetailsSP.dart';
import 'package:kiranas_web/StateManager/CheckoutState.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

Future<bool> isAddressPresent;

Future<dynamic> userDetails;

class AddressDetails extends StatefulWidget {
  final TabController tabController;

  AddressDetails({this.tabController});

  @override
  _AddressDetailsState createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey5 = GlobalKey<FormState>();

  TextEditingController _addressController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _localityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();

  bool confirmAddressButton = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoValidate = false;

  ProgressDialog progressDialogAddress;

  @override
  void initState() {
    super.initState();

    isAddressPresent = UserDetailsSP().isAddressPresent();
    userDetails = UserDetailsSP().getUserDetails();

    isAddressPresent.then((value) {
      var addressState = Provider.of<CheckoutState>(context, listen: false);
      print("isADD :" + value.toString());
      addressState.setIsAddressP(value);
    });

    userDetails.then((value) {
      var addressState = Provider.of<CheckoutState>(context, listen: false);
      String userD = json.encode(value);
      print("Startttttttttttttt");
      print("WWWWWWWWWWW :" + userD.toString());

      addressState.setUserDetails(userD);
    });
  }

  @override
  Widget build(BuildContext context) {
    progressDialogAddress = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialogAddress.style(
        message: "Updating Address...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: scaffoldKey,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
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
                          Expanded(
                            child: SizedBox(
                                height: 3,
                                // width: MediaQuery.of(context).size.width * 0.6,
                                child: Container(
                                  color: Colors.grey[400],
                                  child: widget.tabController.previousIndex == 1
                                      ? Line(
                                          isbackward: true,
                                        )
                                      : null,
                                )),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: Container(
                                height: 10, width: 10, color: Colors.grey[400]),
                          ),
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black))
                        ],
                      )
                    ],
                  )),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: Row(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          children: [getAddress()],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: isAddressPresent,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Consumer<CheckoutState>(
                      builder: (context, address, child) {
                    bool isAddress = address.getIsAddressP();
                    return ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.6,
                      height: 45,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          splashColor: Colors.white,
                          onPressed: isAddress
                              ? address.getButtonAction() == "EDIT"
                                  ? null
                                  : () {
                                      widget.tabController.animateTo(
                                          widget.tabController.index++);
                                    }
                              : null,
                          color: Colors.pink[900],
                          child: Text("CONFIRM DELIVERY ADDRESS",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    );
                  });
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text("...."),
                  );
                }
              }),
        ],
      ),
    );
  }

  dynamic getAddress() {
    return FutureBuilder<dynamic>(
        future: isAddressPresent,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Consumer<CheckoutState>(builder: (context, address, child) {
              bool isAddress = address.getIsAddressP();
              String buttonAction = address.getButtonAction();
              String userD = address.getUserDetails();
              Map<String, dynamic> userAddress = json.decode(userD);

              print("isAddress " + isAddress.toString());
              if (isAddress && buttonAction == "NA") {
                return Column(
                  children: [
                    Row(
                      children: [
                        Text(userAddress["userName"],
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    getAddresss(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getAddressActionButton(
                            label: "EDIT DELIVERY ADDRESS", action: "EDIT")
                      ],
                    )
                  ],
                );
              } else if (isAddress && buttonAction == "EDIT") {
                return Column(
                  children: [
                    getAddressForm(populated: true, userD: userD),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getAddressActionButton(label: "SAVE", action: "SAVE")
                      ],
                    )
                  ],
                );
              } else if (!isAddress && buttonAction == "NA") {
                return Column(
                  children: [
                    getNoAddressImage(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getAddressActionButton(
                            label: "ADD DELIVERY ADDRESS", action: "ADD")
                      ],
                    )
                  ],
                );
              } else if (!isAddress && buttonAction == "ADD") {
                // setState(() {
                //   isAddress = false;
                // });
                return Column(
                  children: [
                    getAddressForm(populated: false),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getAddressActionButton(label: "SAVE", action: "SAVE")
                      ],
                    )
                  ],
                );
              } else {
                return Text("Something went wrong!!");
              }
            });
          } else {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("Loading....."),
            );
          }
        });
  }

  getAddressForm({bool populated, String userD}) {
    Map<String, dynamic> userAddress = new Map<String, dynamic>();
    if (populated) {
      userAddress = json.decode(userD);
    } else {
      userAddress = null;
    }
    return Column(
      children: [
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    key: _formKey,
                    inputFormatters: [
                      new LengthLimitingTextInputFormatter(100),
                    ],

                    autofocus: false,
                    readOnly: false,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    // ignore: deprecated_member_use
                    autovalidate: _autoValidate,
                    validator: null,
                    controller: _addressController
                      ..text = userAddress == null
                          ? ""
                          : userAddress["userAddress"]["address"].toString(),
                    //  enabled: !lreadonlyForm,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    decoration: InputDecoration(
                        labelText: "Address",
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 15)),

                    // focusedBorder: InputBorder.none,
                    // border: InputBorder.none),
                    keyboardType: TextInputType.text,
                  ),
                )),
          ],
        ),
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    key: _formKey1,
                    inputFormatters: [
                      new LengthLimitingTextInputFormatter(50),
                    ],
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    readOnly: false,
                    cursorColor: Colors.black,

                    // ignore: deprecated_member_use
                    autovalidate: _autoValidate,
                    validator: null,
                    controller: _localityController
                      ..text = userAddress == null
                          ? ""
                          : userAddress["userAddress"]["locality"].toString(),
                    //  enabled: !lreadonlyForm,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    decoration: InputDecoration(
                        labelText: "Locality",
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 15)),

                    // focusedBorder: InputBorder.none,
                    // border: InputBorder.none),
                    keyboardType: TextInputType.text,
                  ),
                )),
          ],
        ),
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    key: _formKey2,
                    inputFormatters: [
                      new LengthLimitingTextInputFormatter(44),
                    ],
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    readOnly: false,
                    cursorColor: Colors.black,

                    // ignore: deprecated_member_use
                    autovalidate: _autoValidate,
                    validator: null,
                    controller: _landmarkController
                      ..text = userAddress == null
                          ? ""
                          : userAddress["userAddress"]["landmark"].toString(),
                    //  enabled: !lreadonlyForm,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    decoration: InputDecoration(
                        labelText: "Landmark",
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 15)),

                    // focusedBorder: InputBorder.none,
                    // border: InputBorder.none),
                    keyboardType: TextInputType.text,
                  ),
                )),
          ],
        ),
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    key: _formKey3,
                    inputFormatters: [
                      new LengthLimitingTextInputFormatter(44),
                    ],
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    readOnly: false,
                    cursorColor: Colors.black,

                    // ignore: deprecated_member_use
                    autovalidate: _autoValidate,
                    validator: null,
                    controller: _stateController
                      ..text = userAddress == null
                          ? ""
                          : userAddress["userAddress"]["state"].toString(),
                    //  enabled: !lreadonlyForm,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    decoration: InputDecoration(
                        labelText: "State",
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 15)),

                    // focusedBorder: InputBorder.none,
                    // border: InputBorder.none),
                    keyboardType: TextInputType.text,
                  ),
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.44,
                  child: TextFormField(
                    key: _formKey4,
                    inputFormatters: [
                      new LengthLimitingTextInputFormatter(20),
                    ],
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    readOnly: false,
                    cursorColor: Colors.black,

                    // ignore: deprecated_member_use
                    autovalidate: _autoValidate,
                    validator: null,
                    controller: _cityController
                      ..text = userAddress == null
                          ? ""
                          : userAddress["userAddress"]["city"].toString(),
                    //  enabled: !lreadonlyForm,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    decoration: InputDecoration(
                        labelText: "City",
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 15)),

                    // focusedBorder: InputBorder.none,
                    // border: InputBorder.none),
                    keyboardType: TextInputType.text,
                  ),
                )),
            SizedBox(
              width: 10,
            ),
            Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.44,
                  child: TextFormField(
                    key: _formKey5,
                    inputFormatters: [
                      new LengthLimitingTextInputFormatter(20),
                    ],

                    autofocus: false,
                    readOnly: false,
                    cursorColor: Colors.black,

                    // ignore: deprecated_member_use
                    autovalidate: _autoValidate,
                    validator: null,
                    controller: _pincodeController
                      ..text = userAddress == null
                          ? ""
                          : userAddress["userAddress"]["pincode"].toString(),
                    //  enabled: !lreadonlyForm,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    decoration: InputDecoration(
                        labelText: "Pincode",
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 15)),

                    // focusedBorder: InputBorder.none,
                    // border: InputBorder.none),
                    keyboardType: TextInputType.number,
                  ),
                ))
          ],
        )
      ],
    );
  }

  getNoAddressImage() {
    return Padding(
      padding: const EdgeInsets.all(60.0),
      child: Image.asset(
        'image/broken-house.png',
        color: Colors.grey,
        height: MediaQuery.of(context).size.height / 6,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  getAddresss() {
    return FutureBuilder(
        future: userDetails,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Consumer<CheckoutState>(builder: (context, address, child) {
              String userD = address.getUserDetails();

              Map<String, dynamic> userAddress = json.decode(userD);
              return Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(userAddress["userAddress"]["address"]
                              .toString() +
                          "\n" +
                          userAddress["userAddress"]["landmark"].toString() +
                          "\n" +
                          userAddress["userAddress"]["locality"].toString() +
                          "\n" +
                          userAddress["userAddress"]["state"].toString() +
                          "\n" +
                          userAddress["userAddress"]["city"].toString() +
                          "\n" +
                          userAddress["userAddress"]["pincode"].toString()),
                    )
                  ],
                ),
              );
            });
          } else {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("fetching address..."),
            );
          }
        });
  }

  getAddressActionButton({String action, String label}) {
    var addressState = Provider.of<CheckoutState>(context, listen: false);

    return FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(
              color: Colors.black, width: 1, style: BorderStyle.solid),
        ),
        onPressed: () {
          if (action == "ADD") {
            addressState.setButtonAction("ADD");
          } else if (action == "EDIT") {
            addressState.setButtonAction("EDIT");
          } else if (action == "SAVE") {
            progressDialogAddress.show().then((isShown) {
              if (isShown) {
                LoginController()
                    .updateAddress(
                        address: _addressController.text,
                        city: _cityController.text,
                        landmark: _landmarkController.text,
                        locality: _localityController.text,
                        pincode: _pincodeController.text,
                        state: _stateController.text)
                    .then((value) {
                  if (null != value) {
                    addressState.setButtonAction("NA");
                    addressState.setIsAddressP(true);
                    String userAddress = json.encode(value);
                    addressState.setUserDetails(userAddress);
                    progressDialogAddress.hide();
                  }
                }).catchError((err) {
                  progressDialogAddress.hide();
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
        },
        child:
            Text(label, style: TextStyle(fontSize: 10, color: Colors.black)));
  }
}
