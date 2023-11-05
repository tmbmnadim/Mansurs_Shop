import 'package:flutter/material.dart';
import 'package:maanecommerceui/models/product_model.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:maanecommerceui/screens/add_product_screen.dart';
import 'package:maanecommerceui/screens/get_user_data_screen.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_profile_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late UserModel userData;
  late List<ProductModel> productData = [];
  int pageIndex = 0;
  PageController pageViewController = PageController();

  void _getData() {
    UserProfileProvider userProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    userData = userProvider.user;
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productData.addAll(productProvider.products);
  }

  final List<Widget> bottomPages = [
    const Home(),
    const AddProductScreen(),
    const UserDetailsInput(),
    // const UserCartScreen(),
    // const SettingsScreen(),
  ];
  final List<IconData> bottomIcons = [
    Icons.home,
    Icons.add,
    Icons.person_rounded,
    // Icons.shopping_cart,
    // Icons.settings,
  ];
  final List<String> bottomLabels = [
    "Home",
    "New Product",
    "User Profile",
    // "Shopping Cart",
    // "Settings",
  ];

  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProfileProvider>(context, listen: false).updateUserData();
    Provider.of<ProductProvider>(context, listen: false).updateProductData();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              bottomIcons[0],
            ),
            label: bottomLabels[0],
          ),
          BottomNavigationBarItem(
            icon: Icon(
              bottomIcons[1],
            ),
            label: bottomLabels[1],
          ),
          BottomNavigationBarItem(
            icon: Icon(
              bottomIcons[2],
            ),
            label: bottomLabels[2],
          ),
        ],
        onTap: (index) {
          pageIndex = index;
          pageViewController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
          setState(() {});
        },
      ),
      body: PageView(
        controller: pageViewController,
        children: bottomPages,onPageChanged: (index) {
        setState(() {
          pageIndex = index;
        });
      }
      ),
    );
  }
}
