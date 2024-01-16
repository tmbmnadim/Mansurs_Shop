import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maanecommerceui/models/cart_model.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:maanecommerceui/repos/get_orders_repo.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../repos/get_profile_repo.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartItems = [];
  double subtotal = 0;

  Future<void> getAllCartItems() async {
    cartItems = await getCarts();
    calculateSubtotal();
    notifyListeners();
  }

  calculateSubtotal() {
    subtotal = 0;
    for (var element in cartItems) {
      subtotal += (element.quantity *
          (element.salePrice - (element.salePrice * (element.discount / 100))));
    }
    notifyListeners();
  }

  sentAsOrders(context) async {
    // MakePayment payment = MakePayment();
    //
    // payment.paymentIntentData = await payment.createPaymentIntent(
    //   amount: "${(subtotal * 100).floor()}",
    //   currency: "USD",
    // );
    //
    // await payment.makePaymentRepo(
    //   amount: "${(subtotal * 100).floor()}",
    //   currency: "USD",
    // );

    // await payment.displayPaymentSheet().then(() {
    // if (payment.paymentIntentData!["status"] == "succeeded") {
    for (var cartItem in cartItems) {
      OrderModel order = OrderModel(
        productId: cartItem.productId,
        userID: FirebaseAuth.instance.currentUser!.uid,
        productStock: cartItem.productStock,
        productName: cartItem.productName,
        salePrice: cartItem.salePrice,
        purchasePrice: cartItem.purchasePrice,
        orderTime: Timestamp.now(),
        discount: cartItem.discount,
        quantity: cartItem.quantity,
      );
      postOrderData(order: order);
    }
    Provider.of<ProductProvider>(context, listen: false)
        .orderedProduct(cartItems: cartItems);
    clearCart();
    EasyLoading.showSuccess("Order Placed!");
    // }
    // print(
    //     "---------------------------------------------------------------------------------------\n${payment.paymentIntentData!["status"]}\n---------------------------------------------------------------------------------------");
    // });
  }

  addToCart({required CartModel cartModel}) async {
    if (cartItems.isNotEmpty) {
      for (var element in cartItems) {
        if (element.productId == cartModel.productId) {
          if (element.quantity < cartModel.productStock) {
            changeCart(cartModel: element, addOrRemove: 'add');
            EasyLoading.showSuccess('Item Added to Cart');
            getAllCartItems();
          } else {
            EasyLoading.showError("Out of Stock");
          }
          break;
        }

        if (element == cartItems.last) {
          addToCartRepo(cartModel: cartModel);
          getAllCartItems();
          EasyLoading.showSuccess('Item Added to Cart');
          calculateSubtotal();
        }
      }
    } else {
      await addToCartRepo(cartModel: cartModel);
      EasyLoading.showSuccess('Item Added to Cart');
      getAllCartItems();
    }
    calculateSubtotal();
    notifyListeners();
  }

  removeFromCart({required CartModel cartModel}) async {
    await removeFromCartRepo(cartModel);
    getAllCartItems();
    notifyListeners();
  }

  ///__________________Add_quantity_______________________
  addQuantity({required int index}) async {
    if (cartItems[index].quantity < cartItems[index].productStock) {
      await changeCart(cartModel: cartItems[index], addOrRemove: 'add');
      getAllCartItems();
    } else {
      EasyLoading.showError('Out Of Stock');
    }
    calculateSubtotal();
    notifyListeners();
  }

  subQuantity({required int index}) async {
    if (cartItems[index].quantity <= 1) {
      await removeFromCart(cartModel: cartItems[index]);
    } else {
      await changeCart(cartModel: cartItems[index], addOrRemove: 'remove');
    }
    getAllCartItems();
    calculateSubtotal();
    notifyListeners();
  }

  clearCart() {
    for (var element in cartItems) {
      removeFromCartRepo(element);
    }
    cartItems.clear();
    calculateSubtotal();
    notifyListeners();
  }
}
