import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kiranas_web/CommonScreens/ErrorPage.dart';
import 'package:kiranas_web/CommonScreens/FancyLoader.dart';
import 'package:kiranas_web/CommonScreens/OrderFilterCategoryList.dart';
import 'package:kiranas_web/Controllers/OrderController.dart';
import 'package:kiranas_web/CustomWidgets/OrderFIlter.dart';
import 'package:kiranas_web/Podo/OrdersData.dart';
import 'package:kiranas_web/StateManager/OpenOrderState.dart';
import 'package:kiranas_web/StateManager/OrdersListState.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

FloatingActionButtonLocation fab = FloatingActionButtonLocation.endDocked;
FloatingActionButtonLocation totalFab = FloatingActionButtonLocation.endDocked;

Future<dynamic> openOrdersList;
final DateFormat formatDate = new DateFormat("EEE, d/M/y");
final DateFormat format = new DateFormat.jms();

class OpenOrders extends StatefulWidget {
  final TabController tabController;

  OpenOrders({this.tabController});
  @override
  _OpenOrdersState createState() => _OpenOrdersState();
}

class _OpenOrdersState extends State<OpenOrders> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _controller = ScrollController();

  bool isPaginationActive;
  bool isMoreOrdersAvailable;
  bool isGetMoreOrders;
  ProgressDialog progressDialog;

  setIsMoreOrdersAvailable() {
    isMoreOrdersAvailable = true;
    print("Called BACK");
  }

  getOpenOrdersChunk() {
    openOrdersList = OrderController().getOrdersByType("Open");

    openOrdersList.then((value) {
      var localOpenFilterState =
          Provider.of<OpenOrderState>(context, listen: false);
      localOpenFilterState.clearAll();
      var ordersListState =
          Provider.of<OrdersListState>(context, listen: false);

      ordersListState.setOrdersListState(value);
    });
  }

  getPaginatedOrdersOnlyByType() {
    if (isMoreOrdersAvailable && isGetMoreOrders) {
      setState(() {
        isPaginationActive = true;
        isGetMoreOrders = false;
      });

      var ordersListState =
          Provider.of<OrdersListState>(context, listen: false);
      List<OrdersData> currentOpenOrderListState =
          ordersListState.getOrdersListState();

      String lastOrderID =
          currentOpenOrderListState[(currentOpenOrderListState.length) - 1]
              .orderData
              .orderID;
      int lastOUpdateDate =
          currentOpenOrderListState[(currentOpenOrderListState.length) - 1]
              .orderData
              .oUpdateDate;

      Future openOrdersPaginatedList = OrderController()
          .getPaginatedOrdersByType("Open", lastOrderID, lastOUpdateDate);
      openOrdersPaginatedList.then((value) {
        List<dynamic> paginatedData = value;
        print(paginatedData.length.toString());
        if (paginatedData.length != 0) {
          var ordersListState =
              Provider.of<OrdersListState>(context, listen: false);
          ordersListState.addAllOrdersListState(value);
        } else {
          setState(() {
            isMoreOrdersAvailable = false;
          });
          Fluttertoast.showToast(
              gravity: ToastGravity.CENTER,
              msg: "No more orders !!",
              fontSize: 10,
              backgroundColor: Colors.black);
        }
        setState(() {
          isPaginationActive = false;
          isGetMoreOrders = true;
        });
      });
    }
  }

  @override
  void initState() {
    isPaginationActive = false;
    isMoreOrdersAvailable = true;
    isGetMoreOrders = true;
    fab = FloatingActionButtonLocation.miniCenterFloat;

    // TODO: implement initState
    super.initState();

    getOpenOrdersChunk();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() {
    var openOrderdFilterState =
        Provider.of<OpenOrderState>(context, listen: false);

    if (!openOrderdFilterState.getOpenOrderState()["isNotifcationCue"]) {
      print("filter NOT active");
      double maxScroll = _controller.position.maxScrollExtent;
      double currentScroll = _controller.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.1;
      if (maxScroll - currentScroll <= delta && isMoreOrdersAvailable) {
        getPaginatedOrdersOnlyByType();
      }
    } else {
      print("filter  active");
    }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
        message: "Cancelling Order...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);

    return Scaffold(
      // backgroundColor: Theme.of(context).backgroundColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      body: Container(
        child: getOrders(),
      ),
      floatingActionButtonLocation: fab,

      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      //specify the location of the FAB

      floatingActionButton: FloatingActionButton(
          mini: true,
          child: new Stack(
            children: <Widget>[
              new Icon(
                Icons.filter_alt_outlined,
                color: Colors.white,
                size: 25,
              ),
              new Positioned(
                right: 0.01,
                child:
                    Consumer<OpenOrderState>(builder: (context, data, child) {
                  if (data.getOpenOrderState()["isNotifcationCue"]) {
                    return Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
              )
            ],
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0))),
          backgroundColor: Colors.pink[900],
          splashColor: Colors.white,
          onPressed: () {
            filter(context, 0.60);
            // var searchDateState =
            //     Provider.of<StateManager>(context, listen: false);
            // searchDateState.setSearchDate("WholeList");

            // searchDateState.setClearFilter(false);
          }),
    );
  }

  filter(BuildContext context, double bottomSheetHeight) {
    return showModalBottomSheet(
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        isDismissible: false,
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
                        height: MediaQuery.of(context).size.height *
                            bottomSheetHeight,
                        // width: MediaQuery.of(context).size.height * 0.95,
                        child: SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OrderFilter(
                                setIsMoreOrdersAvailable:
                                    setIsMoreOrdersAvailable,
                                orderType: "Open",
                                mainOrderCategoryList: OrderFilterCategoryList()
                                    .getOpenOrderFilterCategoryList(),
                              )),
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

  Widget getOrders() {
    return FutureBuilder<dynamic>(
      future: openOrdersList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;

          return ErrorPage(error: error.toString());
        } else if (snapshot.hasData) {
          var data = snapshot.data;

          if (data.isEmpty || data.length == 0) {
            return Center(
              child: Text("No Open Orders",
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 15)),
            );
          } else {
            return Scrollbar(child:
                Consumer<OrdersListState>(builder: (context, orders, child) {
              List<OrdersData> orderListState = orders.getOrdersListState();
              for (var item in orderListState) {
                print(item.orderData.oProducts.toString());
              }
              if (orderListState.length > 0) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          controller: _controller,
                          padding: const EdgeInsets.only(
                              bottom: kFloatingActionButtonMargin + 100,
                              top: kFloatingActionButtonMargin + 60),

                          //controller: _scrollController,

                          itemCount: orderListState.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(3, 10, 3, 0),
                                  child: Card(
                                    elevation: 1.0,
                                    child: ExpansionTile(
                                      //tilePadding: EdgeInsets.all(5),

                                      title: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 7, 0, 7),
                                        child: Row(
                                          children: [
                                            Text("Order ID: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            Text(
                                                orderListState[index]
                                                    .orderData
                                                    .orderID,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15))
                                          ],
                                        ),
                                      ),

                                      subtitle: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 5, 0, 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "Tracking status       " +
                                                          orderListState[index]
                                                              .orderData
                                                              .oTrackingStatus
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "Dop                           " +
                                                        "${formatDate.format(new DateTime.fromMillisecondsSinceEpoch(orderListState[index].orderData.oDop))}" +
                                                        "  " +
                                                        "${format.format(new DateTime.fromMillisecondsSinceEpoch(orderListState[index].orderData.oDop))}",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12)),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 5, 0, 5),
                                              child: Row(
                                                children: [
                                                  Text("Est delivery time    ",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12)),
                                                  Flexible(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  2)),
                                                      child: Container(
                                                        color: Colors.pink[900],
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Text(
                                                              orderListState[
                                                                      index]
                                                                  .orderData
                                                                  .oEstDelivaryTime
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize:
                                                                      12)),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      children: <Widget>[
                                        Container(

                                            //   height: 100,

                                            color: Colors.grey[100],
                                            child: inventoryCard1(
                                                orderListState[index])),
                                      ],
                                    ),
                                  ),
                                ),

                                // Divider(

                                //   thickness: 0,

                                //   indent: 0,

                                //   endIndent: 0,

                                // )
                              ],
                            );
                          }),
                    ),
                    isPaginationActive
                        ? CircularProgressIndicator()
                        : SizedBox()
                  ],
                );
              } else {
                return Center(
                  child: Text("No Open Orders!!"),
                );
              }
            }));
          }
        } else {
          return FancyLoader(
            loaderType: "list",
          );
        }
      },
    );
  }

  Widget inventoryCard1(OrdersData orderListState) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 10, 15),
      child: Column(
        children: [
          Row(
            children: [
              Text("Order Details:",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 12))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          inventoryCardDetailsList(orderListState),
          SizedBox(
            height: 5,
          ),
          Divider(thickness: 0.5, endIndent: 5, color: Colors.grey[300]),
          inventoryCardDetails(
              "Delivery Address",
              orderListState.orderData.oUserAddress.address +
                  "\n" +
                  orderListState.orderData.oUserAddress.landmark +
                  "\n" +
                  orderListState.orderData.oUserAddress.locality +
                  "\n" +
                  orderListState.orderData.oUserAddress.state +
                  "\n" +
                  orderListState.orderData.oUserAddress.city +
                  "\n" +
                  orderListState.orderData.oUserAddress.pincode),
          SizedBox(
            height: 5,
          ),
          Divider(thickness: 0.5, endIndent: 5, color: Colors.grey[300]),
          inventoryCardDetails("Bill Details",
              orderListState.orderData.oBillTotal.totalAmt.toString()),
          Divider(thickness: 0.5, endIndent: 5, color: Colors.grey[300]),
          Row(
            children: [
              Text("Actions:",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 12)),
            ],
          ),
          Row(
            children: [
              ButtonTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                minWidth: MediaQuery.of(context).size.width * 0.2,
                height: 20,
                child: RaisedButton(
                  splashColor: Colors.white,
                  color: Colors.redAccent,
                  elevation: 5,
                  onPressed: (orderListState.orderData.oTrackingStatus ==
                              "Placed") ||
                          (orderListState.orderData.oTrackingStatus ==
                              "Accepted")
                      ? () {
                          progressDialog.show().then((isShown) {
                            if (isShown) {
                              OrderController()
                                  .updateOrderStatus(
                                      orderID: orderListState.orderData.orderID,
                                      status: "Cancelled by user")
                                  .then((value) {
                                if (value == "true") {
                                  openOrdersList =
                                      OrderController().getOrdersByType("Open");

                                  openOrdersList.then((value) {
                                    var ordersListState =
                                        Provider.of<OrdersListState>(context,
                                            listen: false);
                                    ordersListState.setOrdersListState(value);
                                    progressDialog.hide().then((value) {
                                      widget.tabController.animateTo(
                                          widget.tabController.index += 2);
                                      Fluttertoast.showToast(
                                          gravity: ToastGravity.CENTER,
                                          msg: "Order Cancelled Successfully!!",
                                          fontSize: 10,
                                          backgroundColor: Colors.black);
                                    });
                                  });
                                }
                              }).catchError((err) {
                                progressDialog.hide();
                                Fluttertoast.showToast(
                                    gravity: ToastGravity.CENTER,
                                    msg:
                                        "Something went wrong! please try later",
                                    fontSize: 10,
                                    backgroundColor: Colors.black);
                                print(err.toString());
                              });
                            }
                          });
                        }
                      : null,
                  child: Text("CANCEL ORDER",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  inventoryCardDetailsList(OrdersData orderListState) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: orderListState.orderData.oProducts.length,
        itemBuilder: (context, index) {
          return Table(
            columnWidths: {
              0: FlexColumnWidth(5),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      orderListState.orderData.oProducts[index].productName
                          .toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 12))
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      "x " +
                          orderListState.orderData.oProducts[index].productQty
                              .toString(),
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 12)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(
                      "\u20B9 " +
                          (int.parse(orderListState
                                      .orderData.oProducts[index].productQty) *
                                  (int.parse(orderListState.orderData
                                          .oProducts[index].productMrp) -
                                      ((orderListState
                                                  .orderData
                                                  .oProducts[index]
                                                  .productOffPercentage /
                                              100) *
                                          int.parse(orderListState.orderData
                                              .oProducts[index].productMrp))))
                              .toString(),
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 12)),
                ]),
              ])
            ],
          );
        });
  }

  Widget inventoryCardDetails(String titleName, String titleValue) {
    return Column(
      children: [
        Row(
          children: [
            Text(titleName + ":",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 12)),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Flexible(
              child: Text(titleValue,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 12)),
            )
          ],
        ),
      ],
    );
  }
}
