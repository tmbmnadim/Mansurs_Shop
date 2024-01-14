import 'package:flutter/material.dart';
import 'package:maanecommerceui/models/order_model.dart';
import '../repos/get_orders_repo.dart';

class OrdersProvider extends ChangeNotifier {
  List<OrderModel> orders = [];
  List<String> userList = [];
  List<List<OrderModel>> userOrders = [];

  Future<void> getOrderData() async {
    orders = await getOrders();
    getUserOrderData();
    notifyListeners();
  }

  Future<void> getUserOrderData() async {
    userList = [];
    userOrders = [];
    for (int i = 0; i < orders.length; i++) {
      if (!userList.contains(orders[i].userID)) {
        userList.add(orders[i].userID);
        userOrders.add([orders[i]]);
      } else {
        userOrders[userList.indexOf(orders[i].userID)].add(orders[i]);
      }
    }
    notifyListeners();
  }

  deleteAllOrders(){
    deleteAllOrders();
    getOrderData();
    notifyListeners();
  }

  deleteOrder({required OrderModel orderModel}) {
    deleteOrderRepo(orderModel: orderModel).then((value) {
      getOrderData();
      notifyListeners();
    });
  }
}
