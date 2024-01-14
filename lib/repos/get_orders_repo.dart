import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../models/order_model.dart';

final CollectionReference _orders =
    FirebaseFirestore.instance.collection("orders");

Future<List<OrderModel>> getOrders() async {
  List<OrderModel> orderData = [];

  try {
    final QuerySnapshot data = await _orders.get();
    for (int i = 0; i < data.docs.length; i++) {
      Map<String, dynamic> product =
          data.docs[i].data() as Map<String, dynamic>;
      OrderModel user = OrderModel.fromJson(json: product);
      user.databaseKey = data.docs[i].id;
      orderData.add(user);
    }
  } catch (e) {
    EasyLoading.showError(e.toString());
  }

  return orderData;
}

Future<void> deleteOrderRepo({required OrderModel orderModel}) async {
  await _orders.doc(orderModel.databaseKey).delete();
}

Future<void> deleteAllOrders() async{
  final QuerySnapshot data = await _orders.get();
  data.docs.clear();
}

Future<void> postOrderData({required OrderModel order}) async {
  try {
    await _orders.add(order.toJson());
  } catch (e) {
    EasyLoading.showError(e.toString());
  }
}
