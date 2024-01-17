import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maanecommerceui/models/product_model.dart';
import 'package:maanecommerceui/providers/cart_provider.dart';
import 'package:maanecommerceui/providers/go_to_page.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:maanecommerceui/screens/Authentication/auth.dart';
import 'package:maanecommerceui/screens/Product/add_product_screen.dart';
import 'package:maanecommerceui/screens/Product/orders_screen.dart';
import 'package:maanecommerceui/screens/Profile/get_user_data_screen.dart';
import 'package:maanecommerceui/screens/Home/homepage.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/profile_provider.dart';
import '../Product/cart_screen.dart';
import '../Product/favourite_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late UserModel userData;
  late List<ProductModel> productData = [];
  int _pageIndex = 0;
  int _bottomIndex = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  PageController pageViewController = PageController();

  void _getData() {
    userData = Provider.of<ProfileProvider>(context, listen: false).user;
    productData
        .addAll(Provider.of<ProductProvider>(context, listen: false).products);
  }

  final List<Widget> bottomPages = [
    const Homepage(),
    const UserCartScreen(),
    const FavouriteScreen(),
    const UserDetailsInput(),
    const AddProductScreen(),
    const OrdersScreen(),
  ];
  final List<IconData> bottomIcons = [
    Icons.home,
    Icons.shopping_cart,
    Icons.favorite,
    Icons.menu,
  ];
  final List<String> bottomLabels = [
    "Home",
    "Cart",
    "Favourites",
    "Menu",
  ];

  void signOut() {
    FirebaseAuth.instance.signOut();
    GoToPageProvider().goToPage(
      context,
      page: const AuthPage(),
    );
  }

  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).updateUserData();
    Provider.of<ProductProvider>(context, listen: false).getProductData();
    Provider.of<CartProvider>(context, listen: false).getAllCartItems();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: Drawer(
        child: Consumer<ProfileProvider>(builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    GoToPageProvider().goToPage(
                      context,
                      page: UserDetailsInput(
                        fullName: value.user.fullName,
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(value.user.image ?? ""),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  value.user.fullName ?? "",
                  style: const TextStyle(fontSize: 25),
                ),
                Card(
                  color: const Color.fromARGB(255, 50, 194, 122),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        _pageIndex = 3;
                      });
                      _key.currentState?.closeEndDrawer();
                    },
                    title: const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                Visibility(
                  visible: value.user.userStat == 'admin',
                  child: Card(
                    color: const Color.fromARGB(255, 50, 194, 122),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _pageIndex = 4;
                        });
                        _key.currentState?.closeEndDrawer();
                      },
                      title: const Text(
                        'Add Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: value.user.userStat == 'admin',
                  child: Card(
                    color: const Color.fromARGB(255, 50, 194, 122),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _pageIndex = 5;
                        });
                        _key.currentState?.closeEndDrawer();
                      },
                      title: const Text(
                        'Orders',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Card(
                  color: Colors.red,
                  child: ListTile(
                    onTap: signOut,
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(
          bottomLabels.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(
              bottomIcons[index],
            ),
            label: bottomLabels[index],
          ),
        ),
        currentIndex: _bottomIndex,
        unselectedItemColor: Colors.black38,
        showUnselectedLabels: false,
        selectedItemColor: _bottomIndex == 2
            ? Colors.red
            : const Color.fromARGB(255, 50, 194, 122),
        selectedIconTheme: const IconThemeData(size: 28),
        onTap: (index) {
          if ((index + 1) == bottomLabels.length) {
            _key.currentState?.openEndDrawer();
          } else {
            _pageIndex = index;
          }
          if (index < bottomLabels.length) {
            _bottomIndex = index;
          }
          setState(() {});
        },
      ),
      body: bottomPages.elementAt(_pageIndex),
    );
  }
}
