
import 'package:flutter/material.dart';
import 'package:maanecommerceui/models/order_model.dart';
import '../repos/get_orders_repo.dart';
import '../repos/get_product_repo.dart';

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

  deleteAllOrders() {
    deleteAllOrders();
    getOrderData();
    notifyListeners();
  }

  deleteUserOrders({required String userId}) {
    for (OrderModel singleOrder in orders) {
      if (singleOrder.userID == userId) {
        changeProductStock(
          productId: singleOrder.productId,
          productStock: singleOrder.productStock,
          amount: singleOrder.quantity,
          addOrRemove: "add",
        );
        deleteOrderRepo(orderModel: singleOrder);
      }
    }

    Future.delayed(Duration.zero).then((value) {
      getOrderData();
      notifyListeners();
    });
  }

  deleteOrder({required OrderModel orderModel}) {
    deleteOrderRepo(orderModel: orderModel).then((value) {
      getOrderData();
      notifyListeners();
    });
  }
}
