import 'package:flutter/material.dart';
import 'package:kiranas_web/CommonScreens/AppBarCommon.dart';
import 'package:kiranas_web/CustomWidgets/AddressDetails.dart';
import 'package:kiranas_web/CustomWidgets/PaymentPage.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: false,
      appBar: new AppBarCommon(
        title: Text(
          "CHECKOUT",
          style: TextStyle(fontSize: 18),
        ),
        centerTile: false,
        context: context,
        notificationCount: Text("i"),
        isTabBar: false,
        searchOwner: "CheckOut",
      ),
      body: WillPopScope(
        onWillPop: () async => true,
        child: Center(
          child: DefaultTabController(
            length: 2,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                AddressDetails(
                  tabController: _tabController,
                ),
                Payment(
                  tabController: _tabController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//  Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 50,
//                     color: Colors.green,
//                   )
