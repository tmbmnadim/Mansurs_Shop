import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  late int productId, productStock, quantity;
  late Timestamp orderTime;
  late String productName, userID;
  late double salePrice, purchasePrice, discount;
  String? databaseKey;

  OrderModel({
    required this.productId,
    required this.userID,
    required this.productStock,
    required this.productName,
    required this.salePrice,
    required this.purchasePrice,
    required this.orderTime,
    required this.discount,
    required this.quantity,
    this.databaseKey,
  });

  OrderModel.fromJson({required Map<String, dynamic> json}) {
    productId = json['productId'];
    userID = json['userID'];
    productStock = json['productStock'];
    orderTime = json['orderTime'];
    quantity = json['quantity'];
    productName = json['productName'];
    salePrice = json['salePrice'];
    purchasePrice = json['purchasePrice'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'productId': productId,
    'userID': userID,
    'productStock': productStock,
    'productName': productName,
    'orderTime': orderTime,
    'quantity': quantity,
    'salePrice': salePrice,
    'purchasePrice': purchasePrice,
    'discount': discount,
  };
}
