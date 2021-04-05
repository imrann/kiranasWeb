import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kiranas_web/CommonScreens/AppBarCommon.dart';
import 'package:kiranas_web/CommonScreens/FancyLoader.dart';
import 'package:kiranas_web/StateManager/CartState.dart';
import 'package:kiranas_web/StateManager/HomeDynamicPage.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

Future<bool> doBuildUI;

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    doBuildUI = Future.delayed(Duration(seconds: 1), () async {
      return Future.value(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: new AppBarCommon(
        title: Text(
          "SHOPPING BAG",
          style: TextStyle(fontSize: 18),
        ),
        trailingIcon: Icons.clear_all_outlined,
        centerTile: false,
        context: context,
        notificationCount: Text("i"),
        isTabBar: false,
        searchOwner: "CartSerach",
      ),
      body: WillPopScope(
          onWillPop: () async => true,
          child: Container(child: getSalesItems())),
      bottomNavigationBar: FutureBuilder<dynamic>(
        future: doBuildUI,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return BottomAppBar(
              elevation: 20,
              child: Consumer<CartState>(builder: (context, cartState, child) {
                return getBottomCartSubmitButton(cartState);
              }),
              //to add a space between the FAB and BottomAppBar

              //color of the BottomAppBar
              color: Colors.white,
            );
          } else {
            return Container(
              height: 20,
              width: MediaQuery.of(context).size.width * 0.8,
              child: FancyLoader(
                loaderType: "sLine",
              ),
            );
          }
        },
      ),
    );
  }

  getBottomCartSubmitButton(CartState cartState) {
    String shortAmtForOrderTotal = (cartState.getGrandTotal < 500)
        ? (500 - cartState.getGrandTotal).toStringAsFixed(1)
        : "0";
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: cartState.getGrandTotal < 500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "please add  " +
                      "\u20B9" +
                      shortAmtForOrderTotal +
                      "  more to order",
                  style: TextStyle(fontSize: 12, color: Colors.red[900]),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  "\u20B9 " + cartState.getGrandTotal.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
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
                    onPressed: cartState.getGrandTotal <= 500
                        ? null
                        : () {
                            if (MediaQuery.of(context).size.width > 800) {
                              var homeDYnamicPageState =
                                  Provider.of<HomeDynamicPageState>(context,
                                      listen: false);
                              homeDYnamicPageState
                                  .setActiveHomePage("checkout");
                              SystemNavigator.routeUpdated(
                                  routeName: '/CheckOut',
                                  previousRouteName: null);
                            } else {
                              Navigator.pushNamed(context, '/CheckOut');
                            }

                            // Navigator.push(
                            //     context,
                            //     SlideRightRoute(
                            //         widget: CheckOut(), slideAction: "horizontal"));
                          },
                    color: Colors.pink[900],
                    child: Text("PROCEED",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getSalesItems() {
    return FutureBuilder<dynamic>(
      future: doBuildUI,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Scrollbar(
              child: Consumer<CartState>(builder: (context, cartState, child) {
            if (cartState.getSalesCartItems().length > 0) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        //controller: _scrollController,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cartState.getSalesCartItems().length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  ListTile(
                                    dense: true,
                                    isThreeLine: true,
                                    title: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                child: Text(
                                                    cartState
                                                        .getSalesCartItems()[
                                                            index]
                                                            ['productName']
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.visible,
                                                    softWrap: true,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                            Text(
                                                cartState
                                                        .getSalesCartItems()[
                                                            index]
                                                            ['productNetWeight']
                                                        .toString() +
                                                    "\t" +
                                                    cartState
                                                        .getSalesCartItems()[
                                                            index]
                                                            ['productUnit']
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.orange))
                                          ],
                                        )
                                      ],
                                    ),
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                          cartState.getSalesCartItems()[index]
                                              ['productUrl']),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "\u20B9" +
                                                  (int.parse(cartState.getSalesCartItems()[
                                                                  index]
                                                              ['productMrp']) -
                                                          cartState.getSalesCartItems()[
                                                                  index][
                                                              'productSingleDiscountAmt'])
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.green[500],
                                                  fontSize: 12),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              "\u20B9" +
                                                  cartState.getSalesCartItems()[
                                                      index]['productMrp'],
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              "\u20B9" +
                                                  cartState
                                                      .getSalesCartItems()[
                                                          index]
                                                          ['productOffPrice']
                                                      .toString() +
                                                  " off",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                cartState.getSalesCartItems()[
                                                    index]['productBrand'],
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "Total :" +
                                                    "\u20B9" +
                                                    cartState
                                                        .getSalesCartItems()[
                                                            index]
                                                            ['productQtyTotal']
                                                        .toString(),
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12,
                                                )),
                                            cartCounter(20, cartState, index),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.end,
                                        //   children: [
                                        //     Text(
                                        //         "Total :" +
                                        //             "\u20B9" +
                                        //             cartState
                                        //                 .getSalesCartItems()[
                                        //                     index]
                                        //                     ['productQtyTotal']
                                        //                 .toString(),
                                        //         style: TextStyle(
                                        //           color: Colors.green,
                                        //           fontSize: 12,
                                        //         )),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0,
                                    indent: 80,
                                    endIndent: 15,
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: priceDetails(cartState),
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: Text("Please add items!!"),
              );
            }
          }));
        } else {
          return FancyLoader(
            loaderType: "list",
          );
        }
      },
    );
  }

  priceDetails(CartState cartState) {
    return Container(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.only(
            top: 30.0, left: 30.0, right: 30.0, bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                Text("Price Details",
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total MRP", style: textStyleBillTotal()),
                  Text("\u20B9 " + cartState.getTotalMrp.toString(),
                      style: textStyleBillTotal())
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Discount on MRP", style: textStyleBillTotal()),
                  Text(
                      "- \u20B9 " +
                          cartState.getTotalDiscount
                              .toStringAsFixed(2)
                              .toString(),
                      style: TextStyle(fontSize: 13, color: Colors.red))
                ],
              ),
            ),
            Row(
              children: [
                Divider(thickness: 0.5, endIndent: 5, color: Colors.red),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Grand Total",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(
                      "\u20B9 " +
                          cartState.getGrandTotal.toStringAsFixed(2).toString(),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("*minimum cart value must be  " + "\u20B9" + "500",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[200])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle textStyleBillTotal() {
    return TextStyle(fontSize: 13);
  }

  Widget cartCounter(double buttonSize, CartState cartState, index) {
    return new Container(
      padding: new EdgeInsets.all(0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (cartState.getSalesCartItems()[index]['productQty'] > 0) {
                cartState.updateSalesCartItems(
                    cartState.getSalesCartItems()[index], index, "sub");
              } else {
                Fluttertoast.showToast(
                    gravity: ToastGravity.CENTER,
                    msg: "minimum quantity",
                    fontSize: 15,
                    backgroundColor: Colors.black);
              }
            },
            child: Container(
              height: buttonSize * 1.2, // height of the button
              width: buttonSize * 1.5,
              decoration: BoxDecoration(
                  color: Colors.pink[900],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20))), // width of the button
              child: Center(
                  child: Icon(
                Icons.remove,
                color: Colors.white,
                size: 15,
              )),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: new Text(
                cartState.getSalesCartItems()[index]['productQty'].toString(),
                style: TextStyle(fontSize: 20)),
          ),
          GestureDetector(
            onTap: () {
              cartState.updateSalesCartItems(
                  cartState.getSalesCartItems()[index]['productObject'],
                  index,
                  "add");
            },
            child: Container(
              height: buttonSize * 1.2, // height of the button
              width: buttonSize * 1.5, // width of the button
              decoration: BoxDecoration(
                  color: Colors.pink[900],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child:
                  Center(child: Icon(Icons.add, color: Colors.white, size: 15)),
            ),
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.largest;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
