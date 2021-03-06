import 'package:flutter/material.dart';
import 'package:kiranas_web/Podo/Product.dart';

class CartState extends ChangeNotifier {
  int salesCountState = 0;

  int getSalesCountState() => salesCountState;

  setSlesCountState() {
    this.salesCountState = ++salesCountState;
    print(salesCountState.toString());
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////////////////////////////

  clearSalesCartItems() {
    this.salesCartItems.clear();
    this.salesCountState = 0;
    this.grandTotal = 0.0;
    this.totalMrp = 0.0;
    this.totalDiscount = 0.0;

    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  updateSalesCartItems(
    dynamic items,
    int index,
    String action,
  ) {
    switch (action) {
      case "add":
        this.salesCartItems[index]['productQty']++;

        this.salesCartItems[index]['productDiscountAmt'] =
            ((this.salesCartItems[index]['productOffPercentage'] / 100) *
                    int.parse(this.salesCartItems[index]['productMrp'])) *
                this.salesCartItems[index]['productQty'];

        this.salesCartItems[index]['productQtyTotal'] =
            (int.parse(this.salesCartItems[index]['productMrp']) -
                    this.salesCartItems[index]['productSingleDiscountAmt']) *
                this.salesCartItems[index]['productQty'];

        this.totalMrp =
            this.totalMrp + int.parse(this.salesCartItems[index]['productMrp']);

        this.totalDiscount = this.totalDiscount +
            ((this.salesCartItems[index]['productOffPercentage'] / 100) *
                int.parse(this.salesCartItems[index]['productMrp']));

        this.grandTotal = (this.totalMrp) - this.totalDiscount;

        break;
      case "sub":
        this.salesCartItems[index]['productQty']--;

        this.salesCartItems[index]['productDiscountAmt'] =
            ((this.salesCartItems[index]['productOffPercentage'] / 100) *
                    int.parse(this.salesCartItems[index]['productMrp'])) *
                this.salesCartItems[index]['productQty'];

        this.salesCartItems[index]['productQtyTotal'] =
            (int.parse(this.salesCartItems[index]['productMrp']) -
                    this.salesCartItems[index]['productSingleDiscountAmt']) *
                this.salesCartItems[index]['productQty'];

        this.totalMrp =
            this.totalMrp - int.parse(this.salesCartItems[index]['productMrp']);

        this.totalDiscount = this.totalDiscount -
            ((this.salesCartItems[index]['productOffPercentage'] / 100) *
                int.parse(this.salesCartItems[index]['productMrp']));

        this.grandTotal = (this.totalMrp) - this.totalDiscount;

        break;

      default:
    }

    notifyListeners();
  }
  ////////////////////////////////////////////////////////////////////////////////////////

  List<Map<String, dynamic>> salesCartItems = List<Map<String, dynamic>>();

  List<Map<String, dynamic>> getSalesCartItems() => salesCartItems;

  bool setSalesCartItems(Product items, int productQtyCount) {
    Map<String, dynamic> salesListMap = new Map<String, dynamic>();
    salesListMap['createDate'] = items.productData.createDate;
    salesListMap['productCategory'] = items.productData.productCategory;
    salesListMap['productCp'] = items.productData.productCp;
    salesListMap['updateDate'] = items.productData.updateDate;

    salesListMap['productID'] = items.productData.productID;
    salesListMap['productName'] = items.productData.productName;
    salesListMap['productUrl'] = items.productData.productUrl;
    salesListMap['productUnit'] = items.productData.productUnit;
    salesListMap['productOffPercentage'] =
        items.productData.productOffPercentage;
    salesListMap['productBrand'] = items.productData.productBrand;
    salesListMap['discontinue'] = items.productData.discontinue;
    salesListMap['productDescription'] = items.productData.productDescription;
    salesListMap['productMrp'] = items.productData.productMrp;
    salesListMap['productQty'] = productQtyCount;
    salesListMap['productNetWeight'] = items.productData.productNetWeight;

    salesListMap['productSingleDiscountAmt'] =
        (salesListMap['productOffPercentage'] / 100) *
            int.parse(salesListMap['productMrp']);

    salesListMap['productDiscountAmt'] =
        ((salesListMap['productOffPercentage'] / 100) *
                int.parse(salesListMap['productMrp'])) *
            productQtyCount;

    salesListMap['productQtyTotal'] = (int.parse(items.productData.productMrp) -
            salesListMap['productSingleDiscountAmt']) *
        productQtyCount;

    this.totalMrp = this.totalMrp +
        (int.parse(salesListMap['productMrp']) * productQtyCount);
    this.totalDiscount =
        this.totalDiscount + salesListMap['productDiscountAmt'];

    this.grandTotal = (this.totalMrp) - this.totalDiscount;
    this.salesCartItems.add(salesListMap);
    this.salesCountState = salesCountState + 1;

    notifyListeners();
    return true;
  }

/////////////////////////////////////////////////////////////////////////////////////////
  double totalMrp = 0.0;
  double totalDiscount = 0.0;

  double grandTotal = 0.0;

  double get getTotalMrp => totalMrp;

  set setTotalMrp(double totalMrp) => this.totalMrp = totalMrp;

  double get getTotalDiscount => totalDiscount;

  set setTotalDiscount(double totalDiscount) =>
      this.totalDiscount = totalDiscount;

  double get getGrandTotal => grandTotal;

  set setGrandTotal(double grandTotal) => this.grandTotal = grandTotal;

  ////////////////////////////////////////////////////////////////////////////////////////
}
