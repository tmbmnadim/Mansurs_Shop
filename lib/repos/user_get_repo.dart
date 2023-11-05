import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../models/user_model.dart';

DocumentReference user =
    FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc("profile");

Future<UserModel> getUser() async {
  UserModel userData = UserModel();

  try {
    final DocumentSnapshot data = await user.get();
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
    await user.set(userModel.toJson());
    EasyLoading.showSuccess('Data Post Done');
  } catch (e) {
    EasyLoading.showError(e.toString());
  }
}
