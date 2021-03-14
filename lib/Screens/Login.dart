import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranas_web/Controllers/LoginController.dart';
import 'package:kiranas_web/Screens/Home.dart';
import 'package:kiranas_web/SharedPref/UserDetailsSP.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';

final DateFormat format = new DateFormat("dd-MM-yyyy").add_jms();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ConfirmationResult confirmationResult;

  var smsCode;

  String errorText = "";
  bool enableResendButton = false;
  String enteredOtp = '';
  ProgressDialog progressDialogotpLogin;

  var onTapRecognizer;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  bool _autoValidate = false;

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    confirmationResult = await _auth.signInWithPhoneNumber(
        phone,
        RecaptchaVerifier(
          size: RecaptchaVerifierSize.compact,
          theme: RecaptchaVerifierTheme.dark,
          onSuccess: () => print('reCAPTCHA Completed!'),
          onError: (FirebaseAuthException error) => print(error),
          onExpired: () => print('reCAPTCHA Expired!'),
        ));
    progressDialogotpLogin.hide().then((isHidden) {
      bottomSlider(phoneNumber: _phoneController.text, isOtpSlider: true);
    });
  }

  StreamController<ErrorAnimationType> errorController;
  StreamController<ErrorAnimationType> errorController1;

  bool hasError = false;
  bool hasError1 = false;

  String phoneNumber = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var container = Container();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    errorController1 = StreamController<ErrorAnimationType>();

    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    errorController1.close();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!!'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'NO',
                  style: TextStyle(color: Colors.pink[900]),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text(
                  'YES',
                  style: TextStyle(color: Colors.pink[900]),
                ),
                onPressed: () {
                  exit(0);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    progressDialogotpLogin = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialogotpLogin.style(
        message: "Please Wait...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        key: scaffoldKey,
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.aspectRatio * 600,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: loginformUI(),
                  ),
                ),
              ),
            )));
  }

  Widget loginformUI() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          reverse: false,
          children: <Widget>[
            SizedBox(
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'LOGIN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.pink[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 0,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: inputOTPField()),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: RichText(
                text: TextSpan(
                    text: "Enter Phone Number ",
                    children: [],
                    style: TextStyle(color: Colors.pink[900], fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(hasError ? "*Invalid Phone Number" : "",
                  style: TextStyle(color: Colors.red, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              height: 60,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "OTP will be sent via SMS on above number",
                style: TextStyle(color: Colors.pink[900], fontSize: 12),
              ),
            ),
            SizedBox(
              height: 0,
            ),
            container,
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
              child: ButtonTheme(
                height: 50,
                child: FlatButton(
                  color: Colors.pink[900],
                  onPressed: () {
                    veryfyAndGetOtp();
                  },
                  child: Center(
                      child: Text(
                    "GET OTP".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Clear",
                    style: TextStyle(color: Colors.pink[900]),
                  ),
                  onPressed: () {
                    _phoneController.clear();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget inputOTPField() {
    return PinCodeTextField(
      length: 10,
      textStyle: TextStyle(
        color: Theme.of(context).primaryColorDark,
      ),
      textInputType: TextInputType.number,
      obsecureText: false,
      animationType: AnimationType.fade,
      inputFormatters: <TextInputFormatter>[
        // ignore: deprecated_member_use
        WhitelistingTextInputFormatter.digitsOnly
      ],
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        // borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 30,
        activeColor: Theme.of(context).primaryColor,
        activeFillColor: Theme.of(context).primaryColor,
        selectedColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).primaryColorDark,
        selectedFillColor: Theme.of(context).primaryColor,
      ),
      animationDuration: Duration(milliseconds: 200),
      backgroundColor: Colors.transparent,
      enableActiveFill: false,
      errorAnimationController: errorController,
      controller: _phoneController,
      onCompleted: (v) {},
      onChanged: (value) {
        setState(() {
          phoneNumber = value;
        });
      },
    );
  }

  onboardingProceed(
      String userName, IdTokenResult userIdToken, StateSetter setModalState) {
    if (userName.length < 4) {
      progressDialogotpLogin.hide().then((isHidden) {
        if (isHidden) {
          setModalState(() {
            hasError = true;
            _autoValidate = true;
          });
        }
      });
    } else {
      setModalState(() {
        hasError = false;
        _autoValidate = false;
      });
      progressDialogotpLogin.show().then((isShown) {
        if (true) {
          LoginController().createUser(userIdToken, userName).then((value) {
            if (value == "true") {
              progressDialogotpLogin.hide().then((isHidden) {
                if (isHidden) {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/Home', ModalRoute.withName('/Home'),
                      arguments: Home(
                        user: _userNameController.text,
                        phone: "+91" + _phoneController.text,
                      ));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Home(
                  //               user: _userNameController.text,
                  //               phone: "+91" + _phoneController.text,
                  //             )));

                  Fluttertoast.showToast(
                      gravity: ToastGravity.CENTER,
                      msg: "Welcome!",
                      fontSize: 10,
                      backgroundColor: Colors.black);
                }
              });
            } else {
              Fluttertoast.showToast(
                  gravity: ToastGravity.CENTER,
                  msg: "Something went wrong! please try later..",
                  fontSize: 10,
                  backgroundColor: Colors.black);
              Navigator.of(context).pop();
            }
          }).catchError((err) {
            progressDialogotpLogin.hide();
            Fluttertoast.showToast(
                gravity: ToastGravity.CENTER,
                msg: "Something went wrong! please try later",
                fontSize: 10,
                backgroundColor: Colors.black);
            print(err.toString());
          });
        }
      });
    }
  }

  veryfyAndProceed(StateSetter setModalState) async {
    if (enteredOtp.length != 6) {
      errorController1
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() {
        hasError1 = true;
        errorText = "Invalid SMS Code";
      });
      progressDialogotpLogin.hide();
    } else {
      setState(() {
        hasError1 = false;
        errorText = "";
      });

      final code = _codeController.text.trim();

      await confirmationResult.confirm(code).then((userCredential) {
        userCredential.user.getIdTokenResult().then((token) {
          Fluttertoast.showToast(
              gravity: ToastGravity.CENTER,
              msg: "Login Successfull",
              fontSize: 10,
              backgroundColor: Colors.black);

          if (userCredential.additionalUserInfo.isNewUser) {
            Navigator.of(context).pop();
            bottomSlider(isOtpSlider: false, userIdToken: token);
          } else {
            LoginController().getUserByID(token).then((value) async {
              if (value != null) {
                if (value['userAddress']['address'].toString().isEmpty ||
                    value['userAddress']['address'].toString() == null ||
                    value['userAddress']['address'].toString().trim() == "") {
                  await UserDetailsSP().setIsAddressPresent(false);
                } else {
                  await UserDetailsSP().setIsAddressPresent(true);
                }
                progressDialogotpLogin.hide().then((isHidden) {
                  if (isHidden) {
                    Navigator.of(context).pop();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/Home', ModalRoute.withName('/Home'),
                        arguments: Home(
                          user: value["userName"],
                          phone: value["userPhone"],
                          userID: value["userId"],
                        ));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => Home(
                    //               user: value["userName"],
                    //               phone: value["userPhone"],
                    //               userID: value["userId"],
                    //             )));
                    Fluttertoast.showToast(
                        gravity: ToastGravity.CENTER,
                        msg: "Welcome Back!",
                        fontSize: 10,
                        backgroundColor: Colors.black);
                  }
                });
              } else {
                progressDialogotpLogin.hide();
              }
            }).catchError((err) {
              progressDialogotpLogin.hide();
              Fluttertoast.showToast(
                  gravity: ToastGravity.CENTER,
                  msg: "Something went wrong! please try later",
                  fontSize: 10,
                  backgroundColor: Colors.black);
              print(err.toString());
            });
          }
        });
      }).catchError((err) {
        progressDialogotpLogin.hide();
        print('Caught $err');
        errorController1
            .add(ErrorAnimationType.shake); // Triggering error shake animation

        if (err.toString().contains("ERROR_INVALID_VERIFICATION_CODE") ||
            err
                .toString()
                .contains("firebase_auth/invalid-verification-code")) {
          setModalState(() {
            hasError1 = true;
            errorText = "Invalid SMS Code";
          });
        }
      });
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  veryfyAndGetOtp() {
// conditions for validating
    Pattern pattern = r'^\d{10}$';
    RegExp regex = new RegExp(pattern);

    if ((!regex.hasMatch(phoneNumber))) {
      errorController
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() {
        hasError = true;
        _autoValidate = false;
      });
    } else {
      setState(() {
        hasError = false;
        _autoValidate = false;
      });
      String phoneNumber = "+91" + _phoneController.text.trim();
      progressDialogotpLogin.show().then((isProgressShown) {
        if (isProgressShown) {
          print(phoneNumber);
          loginUser(phoneNumber, context);
          // Future.delayed(Duration(seconds: 5), () {
          //   progressDialogotpLogin.hide().then((isHidden) {
          //     if (isHidden) {
          //       // Navigator.push(context, SlideRightRoute(widget: OtpScreen()));
          //       //otpSlider();
          //     }
          //   });
          // });
        }
      });
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Container onboardingUI(IdTokenResult userIdToken, StateSetter setModalState) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.aspectRatio * 600,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 14,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: Text(
                "Hellooooo!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.redAccent[200],
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30),
              child: Text(
                "What's your name....",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.redAccent[200],
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
                child: TextFormField(
                  key: _formKey,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(10),
                  ],

                  autofocus: false,
                  readOnly: false,
                  cursorColor: Colors.black,

                  // ignore: deprecated_member_use
                  autovalidate: _autoValidate,
                  validator: _userNameValidator,
                  controller: _userNameController,
                  //  enabled: !lreadonlyForm,y
                  style: TextStyle(color: Colors.pink[900], fontSize: 20),
                  decoration: InputDecoration(
                      labelText: "Enter User Name",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 15)),

                  // focusedBorder: InputBorder.none,
                  // border: InputBorder.none),
                  keyboardType: TextInputType.text,
                )),
            SizedBox(
              height: 70,
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
              child: ButtonTheme(
                splashColor: Colors.pink[900],
                height: 50,
                child: FlatButton(
                  color: Colors.pink[900],
                  onPressed: () {
                    print("OnboardingUI");
                    onboardingProceed(
                        _userNameController.text, userIdToken, setModalState);
                  },
                  child: Center(
                      child: Text(
                    "PROCEED".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(
              height: 14,
            ),
          ],
        ));
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget otpFormUI(StateSetter setModalState) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.5,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'OTP Verification',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.redAccent[200],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Hi " + _userNameController.text.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.redAccent[200],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                "Enter the OTP sent to +91 ",
                                style: TextStyle(
                                  color: Colors.pink[900],
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                phoneNumber,
                                style: TextStyle(
                                    color: Colors.redAccent[200],
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: inputPhoneNumberField()),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(errorText,
                  style: TextStyle(color: Colors.red, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Didn't Recieve the OTP?",
                            style: TextStyle(
                              color: Colors.pink[900],
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 0),
                      Column(
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                  color: Colors.pink[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/Login');
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Login()));
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
              child: ButtonTheme(
                splashColor: Colors.white,
                height: 50,
                child: FlatButton(
                  color: Colors.pink[900],
                  onPressed: () {
                    progressDialogotpLogin.show().then((isSHown) {
                      if (isSHown) {
                        veryfyAndProceed(setModalState);
                      }
                    });

                    // conditions for validating
                  },
                  child: Center(
                      child: Text(
                    "Verify & Proceed".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Clear",
                    style: TextStyle(
                      color: Colors.pink[900],
                    ),
                  ),
                  onPressed: () {
                    _codeController.clear();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _userNameValidator(String value) {
    if (value.trim().length < 4) {
      return 'Must be greator than 3 and smaller than 10 charactors';
    } else
      return null;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////

  bottomSlider(
      {String phoneNumber, bool isOtpSlider, IdTokenResult userIdToken}) {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {},
            child: Scrollbar(
              child: SingleChildScrollView(
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                  return new Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0))),
                    child: isOtpSlider
                        ? otpFormUI(setModalState)
                        : onboardingUI(userIdToken, setModalState),
                  );
                }),
              ),
            ),
          );
        });
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget inputPhoneNumberField() {
    return PinCodeTextField(
      length: 6,
      textStyle: TextStyle(
        color: Theme.of(context).primaryColorDark,
      ),
      textInputType: TextInputType.number,
      obsecureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        // borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 50,
        activeColor: Theme.of(context).primaryColor,
        activeFillColor: Theme.of(context).primaryColor,
        selectedColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).primaryColorDark,
        selectedFillColor: Theme.of(context).primaryColor,
      ),
      animationDuration: Duration(milliseconds: 200),
      backgroundColor: Colors.transparent,
      enableActiveFill: false,
      errorAnimationController: errorController1,
      controller: _codeController,
      textCapitalization: TextCapitalization.characters,
      onCompleted: (v) {},
      onChanged: (value) {
        setState(() {
          enteredOtp = value;
        });
      },
    );
  }
}
