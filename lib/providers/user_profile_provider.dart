import 'package:flutter/material.dart';
import 'package:maanecommerceui/repos/user_get_repo.dart';

import '../models/user_model.dart';

class UserProfileProvider extends ChangeNotifier {
  late UserModel user;
  bool firstLoad = true;

  Future<void> updateUserData() async {
    user = await getUser();
    notifyListeners();
  }
}
