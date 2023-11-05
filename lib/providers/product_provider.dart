import 'package:flutter/material.dart';
import 'package:maanecommerceui/models/product_model.dart';
import '../repos/get_product_repo.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> products = [];

  Future<void> updateProductData() async {
    products = await getProducts();
    notifyListeners();
  }
}
