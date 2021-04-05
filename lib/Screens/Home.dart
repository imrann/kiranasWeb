import 'dart:async';
import 'dart:io';
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:kiranas_web/CommonScreens/ErrorPage.dart';
import 'package:kiranas_web/CommonScreens/FancyLoader.dart';
import 'package:kiranas_web/Controllers/ProductController.dart';
import 'package:kiranas_web/Podo/Product.dart';
import 'package:kiranas_web/Screens/Cart.dart';
import 'package:kiranas_web/Screens/CheckOut.dart';
import 'package:kiranas_web/Screens/Orders.dart';
import 'package:kiranas_web/Screens/ProductDetails.dart';
import 'package:kiranas_web/CommonScreens/AppBarCommon.dart';

import 'package:flutter/material.dart';
import 'package:kiranas_web/StateManager/CartState.dart';
import 'package:kiranas_web/StateManager/HomeDynamicPage.dart';
import 'package:kiranas_web/StateManager/ProductListState.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'DrawerNav.dart';

Future<dynamic> productList;
Future<String> image;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex =
      0; //to handle which item is currently selected in the bottom app bar
  String text = "Home";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  initState() {
    super.initState();

    // final ref =
    //     FirebaseStorage.instance.ref().child('image_cropper_1612637899989');
    // image = ref.getDownloadURL();
    // image.then((imaged) {
    //   print("asasasasasasasssss:  " + imaged.toString());
    // });

    productList = ProductController().getProductList();
    productList.then((value) async {
      var productState = Provider.of<ProductListState>(context, listen: false);
      productState.setProductListState(value);
    }).catchError((err) {
      progressDialog.hide();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "$err",
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 5),
      ));
    });
  }

  Future onSelectNotification(String payload) {
    return Navigator.pushNamedAndRemoveUntil(
        context, '/Orders', ModalRoute.withName('/Home'),
        arguments: Orders(initialTabIndex: payload));
  }

  void updateTabSelection(int index, String buttonText) {
    setState(() {
      selectedIndex = index;
      text = buttonText;
    });
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
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
        message: "Please Wait...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: new AppBarCommon(
        title: Text(
          "BRANDED BANIA",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.pink[900],
              fontStyle: FontStyle.italic),
        ),
        profileIcon: Icons.search,
        trailingIcon: Icons.filter_alt_outlined,
        centerTile: true,
        context: context,
        notificationCount: Text("i"),
        isTabBar: false,
        searchOwner: "ProductSearch",
      ),
      drawer: MediaQuery.of(context).size.width > 800.0
          ? null
          : Drawer(
              child: DrawerNav(),
            ),
      body: WillPopScope(
          onWillPop: _onBackPressed,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: MediaQuery.of(context).size.width > 800.0
                  ? Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              color: Colors.white,
                              width: 250,
                              height: MediaQuery.of(context).size.height,
                              child: DrawerNav(),
                            )
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height,
                                child: Consumer<HomeDynamicPageState>(
                                    builder: (context, data, child) {
                                  if (data.getActiveHomePage() == "orders") {
                                    return Orders(
                                      initialTabIndex: "0",
                                    );
                                  } else if (data.getActiveHomePage() ==
                                      "cart") {
                                    return Cart();
                                  } else if (data.getActiveHomePage() ==
                                      "checkout") {
                                    return CheckOut();
                                  } else if (data.getActiveHomePage() ==
                                      "productDetails") {
                                    return ProductDetails(
                                      productDetails: data.getProductDetails(),
                                    );
                                  } else {
                                    return productListUI();
                                  }
                                }),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  : productListUI(),
            ),
          )),
      bottomNavigationBar: MediaQuery.of(context).size.width < 800.0
          ? BottomAppBar(
              child: Container(
                margin: EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    getIconButton(0, "Home", Icons.home),
                    getIconButton(1, "Orders", Icons.archive),

                    //getIconButton(1, "Orders", Icons.),
                    // FlatButton(
                    //     onPressed: () {
                    //       updateTabSelection(1, "Orders");

                    //     },
                    //     child: Text(
                    //       "ORDERS",
                    //       style: TextStyle(
                    //           color: Colors.grey[400],
                    //           fontSize: 17,
                    //           fontWeight: FontWeight.bold),
                    //     )),

                    //to leave space in between the bottom app bar items and below the FAB

                    getIconButton(2, "Cart", Icons.shopping_cart)
                  ],
                ),
              ),
              //to add a space between the FAB and BottomAppBar
              shape: CircularNotchedRectangle(),
              //color of the BottomAppBar
              color: Colors.white,
            )
          : null,
    );

    /// );
  }

  Widget productListUI() {
    return FutureBuilder<dynamic>(
      future: productList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;

          return ErrorPage(error: error.toString());
        } else if (snapshot.hasData) {
          List<Product> data = snapshot.data;

          if (data.isEmpty || data.length == 0) {
            return Center(
              child: Text("0 Products!",
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 15)),
            );
          } else {
            return RefreshIndicator(
              strokeWidth: 3,
              displacement: 200,
              color: Colors.pink[900],
              onRefresh: () {
                return refreshPage();
              },
              key: _refreshIndicatorKey,
              child: Scrollbar(child: Consumer<ProductListState>(
                  builder: (context, product, child) {
                List<Product> productList = product.getProductListState();
                if (productList.length != 0) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ((MediaQuery.of(context).size.width >=
                                    450.0) &&
                                (MediaQuery.of(context).size.width <= 900.0))
                            ? 3
                            : ((MediaQuery.of(context).size.width > 900.0) &&
                                    (MediaQuery.of(context).size.width <=
                                        1250.0))
                                ? 4
                                : (MediaQuery.of(context).size.width > 1250.0)
                                    ? 6
                                    : 2,
                        childAspectRatio: 0.7),
                    itemCount: productList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          if (MediaQuery.of(context).size.width > 800.0) {
                            var homeDYnamicPageState =
                                Provider.of<HomeDynamicPageState>(context,
                                    listen: false);
                            SystemNavigator.routeUpdated(
                                routeName: '/ProductDetails',
                                previousRouteName: null);
                            homeDYnamicPageState
                                .setActiveHomePage("productDetails");
                            homeDYnamicPageState
                                .setProductDetails(productList[index]);
                          } else {
                            Navigator.pushNamed(context, '/ProductDetails',
                                arguments: ProductDetails(
                                  productDetails: productList[index],
                                  heroIndex: "productDetails$index",
                                ));
                          }

                          // Navigator.push(
                          //     context,
                          //     SlideRightRoute(
                          //         widget: ProductDetails(
                          //           productDetails: productList[index],
                          //           heroIndex: "productDetails$index",
                          //         ),
                          //         slideAction: "horizontal"));
                        },
                        child: new Card(
                          elevation: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10),
                                top: Radius.circular(10)),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  productList[index].productData.discontinue
                                      ? Colors.grey[500]
                                      : Colors.white,
                                  BlendMode.modulate),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        child: Stack(
                                          children: [
                                            new FadeInImage.memoryNetwork(
                                                fit: BoxFit.contain,
                                                placeholder: kTransparentImage,
                                                width: double.infinity,
                                                image: productList[index]
                                                    .productData
                                                    .productUrl),
                                            Positioned(
                                                top: 5,
                                                right: 5,
                                                child: Container(
                                                  color: (productList[index]
                                                                  .productData
                                                                  .productNetWeight ==
                                                              "") &&
                                                          (productList[index]
                                                                  .productData
                                                                  .productUnit ==
                                                              "")
                                                      ? Colors.transparent
                                                      : Colors.pink[900],
                                                  child: Text(
                                                    productList[index]
                                                            .productData
                                                            .productNetWeight +
                                                        "  " +
                                                        productList[index]
                                                            .productData
                                                            .productUnit,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white),
                                                  ),
                                                )),
                                            // Positioned(
                                            //     top: 20,
                                            //     right: 5,
                                            //     child: Container(
                                            //       color: Colors.pink[900],
                                            //       child: Text(
                                            //         productList[index]
                                            //                 .productData
                                            //                 .productOffPercentage
                                            //                 .toStringAsFixed(
                                            //                     1) +
                                            //             " % off",
                                            //         style: TextStyle(
                                            //             fontSize: 10,
                                            //             fontStyle:
                                            //                 FontStyle.italic,
                                            //             color: Colors.white),
                                            //       ),
                                            //     )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          Row(
                                            children: [
                                              SizedBox(width: 8),
                                              Container(
                                                width: ((MediaQuery.of(context)
                                                                .size
                                                                .width >=
                                                            450.0) &&
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width <=
                                                            800.0))
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.25
                                                    : ((MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                800.0) &&
                                                            (MediaQuery.of(context)
                                                                    .size
                                                                    .width <=
                                                                1100.0))
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15
                                                        : (MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                1100.0)
                                                            ? MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.12
                                                            : MediaQuery.of(context).size.width * 0.4,
                                                child: Text(
                                                  productList[index]
                                                      .productData
                                                      .productName,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow: TextOverflow.fade,
                                                  softWrap: true,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          Row(
                                            children: [
                                              SizedBox(width: 8),
                                              Text(
                                                "MRP : ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                "\u20B9 " +
                                                    productList[index]
                                                        .productData
                                                        .productMrp,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 14),
                                              ),
                                              SizedBox(width: 12),
                                            ],
                                          ),
                                          SizedBox(height: 3),
                                          Row(
                                            children: [
                                              SizedBox(width: 8),
                                              Text(
                                                "Discount : "
                                                        "\u20B9 " +
                                                    productList[index]
                                                        .productData
                                                        .productOffPrice
                                                        .toString() +
                                                    " off",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 3),
                                          Row(
                                            children: [
                                              SizedBox(width: 8),
                                              Text(
                                                "Final Price : "
                                                        "\u20B9 " +
                                                    (double.parse(productList[
                                                                    index]
                                                                .productData
                                                                .productMrp) -
                                                            double.parse(
                                                                productList[
                                                                        index]
                                                                    .productData
                                                                    .productOffPrice))
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              // Text(
                                              //   "\u20B9" +
                                              //       (double.parse(productList[
                                              //                       index]
                                              //                   .productData
                                              //                   .productMrp) -
                                              //               ((productList[index]
                                              //                           .productData
                                              //                           .productOffPercentage /
                                              //                       100) *
                                              //                   double.parse(productList[
                                              //                           index]
                                              //                       .productData
                                              //                       .productMrp)))
                                              //           .toStringAsFixed(2),
                                              //   style: TextStyle(
                                              //     color: Colors.black,
                                              //     fontSize: 13,
                                              //     fontWeight: FontWeight.bold,
                                              //   ),
                                              // ),
                                              SizedBox(width: 12),
                                            ],
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          productList[index]
                                                      .productData
                                                      .productBrand !=
                                                  ""
                                              ? Row(
                                                  children: [
                                                    SizedBox(width: 8),
                                                    Text(
                                                      productList[index]
                                                          .productData
                                                          .productBrand,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: 0,
                                                ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("0 Search Result!"));
                }
              })),
            );
          }
        } else {
          return FancyLoader(
            loaderType: "Grid",
          );
        }
      },
    );
  }

  // Future<String> getimage() async {
  //   final ref =
  //       FirebaseStorage.instance.ref().child('image_cropper_1612637899989');
  //   FutureBuilder<dynamic>(
  //       future: ref.getDownloadURL(),
  //       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //         if (snapshot.hasData) {
  //           return snapshot.data;
  //         } else {
  //             String dd ="https://mir-s3-cdn-cf.behance.net/projects/404/cf582054480123.Y3JvcCwxMjcxLDk5NCwwLDEyOA.png";
  //           return dd;
  //         }
  //       });

  //   // ref.getDownloadURL().then((value) {
  //   //   return value;
  //   // });
  // }

  Future<void> refreshPage() async {
    productList = ProductController().getProductList();
    return productList.then((value) {
      var productState = Provider.of<ProductListState>(context, listen: false);
      productState.setProductListState(value);
    }).catchError((err) {
      progressDialog.hide();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "$err",
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 5),
      ));
    });
  }

  Widget getIconButton(int sIndex, String pageName, IconData pageIcon) {
    if (sIndex == 1) {
      return FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, '/Orders',
                arguments: Orders(
                  initialTabIndex: "0",
                ));
            // Navigator.push(
            //     context,
            //     SlideRightRoute(
            //         widget: Orders(
            //       initialTabIndex: "0",
            //     )));

            updateTabSelection(0, "Home");
          },
          child: Text(
            "ORDERS",
            style: TextStyle(
                color: selectedIndex == sIndex
                    ? Colors.pink[900]
                    : Colors.grey[400],
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ));
    } else {
      return IconButton(
        //update the bottom app bar view each time an item is clicked
        onPressed: () {
          updateTabSelection(sIndex, pageName);
          switch (pageName) {
            case "Home":
              {
                updateTabSelection(0, "Home");
              }
              break;

            case "Cart":
              {
                updateTabSelection(0, "Home");
                //  Navigator.push(context, SlideRightRoute(widget: Cart()));
                Navigator.pushNamed(context, '/Cart');
                //   Navigator.push(context, SlideRightRoute(widget: Cart()));
              }
              break;

            default:
              {}
              break;
          }
        },
        iconSize: 27.0,
        icon: sIndex == 2
            ? new Stack(
                children: <Widget>[
                  new Icon(
                    pageIcon,
                    //darken the icon if it is selected or else give it a different color
                    color: selectedIndex == sIndex
                        ? Colors.pink[900]
                        : Colors.grey[400],
                  ),
                  new Positioned(
                    right: 0,
                    child: new Container(
                        padding: EdgeInsets.all(0),
                        decoration: new BoxDecoration(
                          color: Colors.pink[900],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 13,
                          minHeight: 10,
                        ),
                        child: Consumer<CartState>(
                            builder: (context, data, child) {
                          return Text(
                            data.getSalesCountState().toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          );
                        })),
                  ),
                ],
              )
            : new Icon(
                pageIcon,
                //darken the icon if it is selected or else give it a different color
                color: selectedIndex == sIndex
                    ? Colors.pink[900]
                    : Colors.grey[400],
              ),
      );
    }
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(10, 50, 170, 170);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
