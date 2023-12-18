import 'package:flutter/material.dart';
import 'package:maanecommerceui/models/cart_model.dart';
import 'package:maanecommerceui/models/product_model.dart';
import 'package:maanecommerceui/providers/profile_provider.dart';
import '../repos/get_product_repo.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> products = [];

  Future<void> getProductData() async {
    products = await getProducts();
    getFavourites();
    notifyListeners();
  }

  orderedProduct({required List<CartModel> cartItems}) {
    for (var item in cartItems) {
      int productIndex =
          products.indexWhere((element) => element.productId == item.productId);
      changeProductStock(
          productId: products[productIndex].productId,
          productStock: products[productIndex].productStock,
          amount: item.quantity,
          addOrRemove: "remove");
    }
  }

  Future<void> getFavourites() async {
    for (var element in products) {
      if (ProfileProvider().favourites.contains(element.productId)) {
        element.isFavourite = true;
      }
    }
    notifyListeners();
  }
}
