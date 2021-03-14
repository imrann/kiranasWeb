import 'package:flutter/material.dart';
import 'package:kiranas_web/CommonScreens/AppBarCommon.dart';
import 'package:kiranas_web/Screens/CancelledOrders.dart';
import 'package:kiranas_web/Screens/DeliveredOrders.dart';
import 'package:kiranas_web/Screens/OpenOrders.dart';
import 'package:kiranas_web/StateManager/CancelledOrderState.dart';
import 'package:kiranas_web/StateManager/DeliveredOrderState.dart';
import 'package:kiranas_web/StateManager/OpenOrderState.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  final String initialTabIndex;
  Orders({this.initialTabIndex});
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    _tabController = TabController(
        length: 3,
        initialIndex: int.parse(widget.initialTabIndex),
        vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    var localOpenFilterState =
        Provider.of<OpenOrderState>(context, listen: false);
    var localDeliveredFilterState =
        Provider.of<DeliveredOrderState>(context, listen: false);
    var localCancelledFilterState =
        Provider.of<CancelledOrderState>(context, listen: false);
    localOpenFilterState.clearAll();
    localDeliveredFilterState.clearAll();

    localCancelledFilterState.clearAll();

    Navigator.of(context).pop(true);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        key: scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: new AppBarCommon(
          //  title: Text("ORDERS"),
          profileIcon: Icons.search,
          trailingIcon: Icons.filter_alt_outlined,
          centerTile: false,
          context: context,
          notificationCount: Text("i"),
          isTabBar: true,
          searchOwner: "OrdersSearch",
          tabController: _tabController,
        ),
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: TabBarView(
            controller: _tabController,
            children: [
              new OpenOrders(
                tabController: _tabController,
              ),
              new DeliveredOrders(),
              new CancelledOrders()
              // DeliveredOrders(),
              // CancelledOrders()
            ],
          ),
        ),
      ),
    );
  }
}
