import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maanecommerceui/models/cart_model.dart';
import '../models/user_model.dart';

CollectionReference userRepo = FirebaseFirestore.instance
    .collection("users")
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection("userData");

Future<UserModel> getUserData() async {
  UserModel userData = UserModel();

  try {
    final DocumentSnapshot data = await userRepo.doc('profile').get();
    userData = UserModel.fromJson(
        json: ((data.data() ?? <String, dynamic>{}) as Map<String, dynamic>));
  } catch (e) {
    EasyLoading.showError(e.toString());
  }

  return userData;
}

Future<void> postUserData({required UserModel userModel}) async {
  try {
    EasyLoading.show(status: 'Loading...');
    await userRepo.doc('profile').set(userModel.toJson());
    EasyLoading.showSuccess('Data Post Done');
  } catch (e) {
    EasyLoading.showError(e.toString());
  }
}

Future<List> getFavourites() async {
  List favourites = [];
  UserModel userData = await getUserData();
  favourites.addAll(userData.favouritesList??[]);

  return favourites;
}

Future<void> changeFavouriteRepo({required List favourites}) async {
  userRepo.doc('profile').update({'favouritesList': favourites});
  getFavourites();
}

Future<List<CartModel>> getCarts() async {
  List<CartModel> cart = [];
  QuerySnapshot data = await userRepo.get();

  if (data.docs.isNotEmpty) {
    for (int i = 0; i < data.docs.length; i++) {
      if (data.docs[i].id != "profile") {
        Map<String, dynamic> singleData =
            data.docs[i].data() as Map<String, dynamic>;
        CartModel cartModel = CartModel.fromJson(json: singleData);
        cart.add(cartModel);
      }
    }
  }

  return cart;
}

Future<void> addToCartRepo({required CartModel cartModel}) async {
  DocumentReference userRepoDoc = userRepo.doc("${cartModel.productId}");
  await userRepoDoc.set(cartModel.toJson());
}

Future<void> changeCart(
    {required CartModel cartModel, required String addOrRemove}) async {
  if (addOrRemove == 'add') {
    await userRepo
        .doc("${cartModel.productId}")
        .update({'quantity': (cartModel.quantity + 1)});
  } else if (addOrRemove == 'remove' && cartModel.quantity > 1) {
    await userRepo
        .doc("${cartModel.productId}")
        .update({'quantity': (cartModel.quantity - 1)});
  }
}

Future<void> removeFromCartRepo(CartModel cartModel) async {
  await userRepo.doc("${cartModel.productId}").delete();
}
