import 'package:flutter/material.dart';
import 'package:maanecommerceui/repos/get_profile_repo.dart';

import '../models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  late UserModel user;
  late List favourites;
  bool firstLoad = true;

  Future<void> updateUserData() async {
    user = await getUserData();
    notifyListeners();
  }

  Future<void> getFavouriteProducts() async {
    favourites = await getFavourites();
    notifyListeners();
  }

  Future<void> changeFavourite({required productID}) async {
    if (favourites.contains(productID)) {
      favourites.remove(productID);
    } else {
      favourites.add(productID);
    }
    changeFavouriteRepo(favourites: favourites);
    getFavourites();
    notifyListeners();
  }

}
