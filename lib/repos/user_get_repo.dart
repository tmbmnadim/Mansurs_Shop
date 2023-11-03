import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../models/user_model.dart';

final User? _user = FirebaseAuth.instance.currentUser;

Future<UserModel> getUser() async {
  UserModel userData;

  // List<UserModel> allStudent = [];
  DocumentReference user = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser?.uid ?? 'users')
      .doc("profile");

  final DocumentSnapshot data = await user.get();
  userData = UserModel.fromJson(json: ((data.data()?? <String, dynamic>{}) as Map<String, dynamic>));
  // for (int i = 0; i < data.docs.length; i++) {
  //   Map<String, dynamic> student = data.docs[i].data() as Map<String, dynamic>;
  //   UserModel user = UserModel.fromJson(json: student);
  //   user.id = data.docs[i].id;
  //   allStudent.add(user);
  // }

  return userData;
}

Future<void> postUserData({required UserModel userModel}) async {
  DocumentReference user = FirebaseFirestore.instance
      .collection(_user?.uid ?? 'users')
      .doc("profile");
  EasyLoading.show(status: 'Loading...');
  print("Pushinggg......");
  await user.set(userModel);
  print("Pushed.....");
  EasyLoading.showSuccess('Data Post Done');
}
