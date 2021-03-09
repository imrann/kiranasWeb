import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kiranas_web/CommonScreens/AppBarCommon.dart';
import 'package:kiranas_web/Podo/Product.dart';
import 'package:kiranas_web/StateManager/CartState.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

bool isItemPresentInCart;

class ProductDetails extends StatefulWidget {
  ProductDetails({this.productDetails, this.heroIndex});

  final Product productDetails;
  final String heroIndex;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int produstQtyCounter = 1;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    isItemPresentInCart = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: new AppBarCommon(
        // title: Text(
        //   widget.productDetails.productData.productName,
        //   style: TextStyle(fontSize: 15),
        // ),
        profileIcon: Icons.shopping_cart_outlined,
        centerTile: false,
        context: context,
        notificationCount: Text("i"),
        isTabBar: false,
        searchOwner: "pDetails",
      ),
      body: WillPopScope(
        onWillPop: () async => true,
        child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Colors.pink[100], Colors.white])),
            child: getProductDetails()),
      ),

      bottomNavigationBar: BottomAppBar(
          color: Colors.pink[100],
          elevation: 0,
          child: widget.productDetails.productData.discontinue
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 0.0, bottom: 30.0, right: 20),
                      child: ButtonTheme(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minWidth: MediaQuery.of(context).size.width * 0.4,
                        height: 45,
                        child: RaisedButton(
                          splashColor: Colors.white,
                          color: Colors.pink[900],
                          elevation: 5,
                          onPressed: null,
                          child: Text("OUT OF STOCK",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 0.0, bottom: 30.0, left: 20),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width * 0.1,
                            height: 45,
                            child: RaisedButton(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              splashColor: Colors.white,
                              onPressed: () {
                                if (produstQtyCounter > 1) {
                                  setState(() {
                                    produstQtyCounter--;
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      gravity: ToastGravity.CENTER,
                                      msg: "minimum quantity",
                                      fontSize: 15,
                                      backgroundColor: Colors.black);
                                }
                              },
                              color: Colors.pink[900],
                              child: Icon(
                                Icons.remove,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: new Text(produstQtyCounter.toString(),
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width * 0.1,
                            height: 45,
                            child: RaisedButton(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              splashColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  produstQtyCounter++;
                                });
                              },
                              color: Colors.pink[900],
                              child: Icon(
                                Icons.add,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 0.0, bottom: 30.0, right: 20),
                      child: ButtonTheme(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minWidth: MediaQuery.of(context).size.width * 0.4,
                        height: 45,
                        child: RaisedButton(
                          splashColor: Colors.white,
                          color: Colors.pink[900],
                          elevation: 5,
                          onPressed: () {
                            var cartState =
                                Provider.of<CartState>(context, listen: false);

                            addToCart(widget.productDetails, produstQtyCounter,
                                cartState);
                          },
                          child: Text("ADD TO CART",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                )),

      // Center(
      //   child: Hero(
      //     tag: widget.heroIndex,
      //     child: FadeInImage.memoryNetwork(
      //       placeholder: kTransparentImage,
      //       image:
      //           'http://clipart-library.com/images_k/food-transparent-background/food-transparent-background-7.png',
      //     ),
      //   ),
      // ),
    );
  }

  getProductDetails() {
    return ListView(
      padding: EdgeInsets.zero,
      // physics: ScrollPhysics(),
      // shrinkWrap: true,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(250),
          ),
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            height: MediaQuery.of(context).size.height * 0.6,
            fit: BoxFit.fitHeight,
            // width: double.infinity,
            alignment: Alignment.center,
            image: widget.productDetails.productData.productUrl,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  widget.productDetails.productData.productName,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.productDetails.productData.productBrand,
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        widget.productDetails.productData.productNetWeight +
                            "  " +
                            widget.productDetails.productData.productUnit,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "\u20B9" + widget.productDetails.productData.productMrp,
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 15),
                      ),
                      SizedBox(width: 12),
                      Text(
                        widget.productDetails.productData.productOffPercentage
                                .toString() +
                            "%" +
                            " off",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "\u20B9",
                        style:
                            TextStyle(color: Colors.green[500], fontSize: 25),
                      ),
                      Text(
                        (int.parse(widget
                                    .productDetails.productData.productMrp) -
                                ((widget.productDetails.productData
                                            .productOffPercentage /
                                        100) *
                                    int.parse(widget.productDetails.productData
                                        .productMrp)))
                            .toString(),
                        style:
                            TextStyle(color: Colors.green[500], fontSize: 50),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Flexible(
                child: new Text(
                  "Description" +
                      "\n" +
                      widget.productDetails.productData.productDescription,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontStyle: FontStyle.italic),
                  softWrap: true,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Text(
                "Category: " +
                    widget.productDetails.productData.productCategory,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ],
    );
  }

  addToCart(Product productDetails, int productQty, CartState cartState) {
    for (var itemMap in cartState.getSalesCartItems()) {
      if (itemMap['productID'] == productDetails.productData.productID) {
        isItemPresentInCart = true;
      }
    }

    if (isItemPresentInCart) {
      Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: "Item already added!",
          fontSize: 15,
          backgroundColor: Colors.black);
    } else {
      bool result = cartState.setSalesCartItems(productDetails, productQty);
      if (result) {
        Fluttertoast.showToast(
            gravity: ToastGravity.CENTER,
            msg: "Item added to cart",
            fontSize: 15,
            backgroundColor: Colors.black);
      }
    }
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(20, 20, 450, 450);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
