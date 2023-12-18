import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maanecommerceui/models/product_model.dart';

final CollectionReference _allProducts =
    FirebaseFirestore.instance.collection("products");

Future<List<ProductModel>> getProducts() async {
  List<ProductModel> productData = [];

  try {
    final QuerySnapshot data = await _allProducts.get();
    for (int i = 0; i < data.docs.length; i++) {
      Map<String, dynamic> product =
          data.docs[i].data() as Map<String, dynamic>;
      ProductModel user = ProductModel.fromJson(json: product);
      user.databaseKey = data.docs[i].id;
      productData.add(user);
    }
  } catch (e) {
    EasyLoading.showError(e.toString());
  }

  return productData;
}

Future<void> changeProductStock({required int productId, required int productStock, required int amount, required String addOrRemove}) async {
  if(addOrRemove == "add"){
    await _allProducts.doc("$productId").update({'productStock': productStock});
  } else if(addOrRemove == "remove"){
    await _allProducts.doc("$productId").update({'productStock': productStock-amount});
  }
}

Future<void> postProductData({required ProductModel productModel}) async {
  try {
    EasyLoading.show(status: 'Loading...');
    await _allProducts.doc("${productModel.productId}").set(productModel.toJson());
    EasyLoading.showSuccess('Data Post Done');
  } catch (e) {
    EasyLoading.showError(e.toString());
  }
}
