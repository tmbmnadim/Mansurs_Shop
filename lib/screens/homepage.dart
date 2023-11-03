import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maanecommerceui/custom_widgets/horizontal_banner.dart';
import 'package:maanecommerceui/custom_widgets/my_widgets.dart';
import 'package:maanecommerceui/providers/go_to_page.dart';
import 'package:maanecommerceui/screens/get_user_data_screen.dart';
import 'package:provider/provider.dart';
import '../custom_widgets/shopping_card.dart';
import '../models/user_model.dart';
import '../providers/user_profile_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final User? _user = FirebaseAuth.instance.currentUser;
  late UserModel userData;
  UtilManager utilManager = UtilManager();
  TextEditingController searchController = TextEditingController();

  void _getData() {
    UserProfileProvider userProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    userData = userProvider.user;
  }

  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProfileProvider>(context, listen: false).updateUserData();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppbar(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: userTitle(),
              backgroundColor: Colors.white,
              toolbarHeight: screenSize.height * 0.15,
              floating: true,
              pinned: true,
              bottom: searchAppBar(screenSize.width),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                width: screenSize.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => BannerWithText(
                      width: screenSize.width - 50,
                      title: 'New Customer',
                      image: "images/onboarding0.png",
                      discount: "25%",
                      backgroundColor: const Color.fromARGB(255, 253, 126, 123),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 300,
                width: screenSize.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShoppingCard(
                        productImage: 'images/apple.png',
                        productName: 'Apple',
                        category: 'Electronics',
                        price: 100,
                        discount: 10,
                        isFavourite: isFavourite,
                        onFavourite: () {
                          isFavourite = !isFavourite;
                          setState(() {});
                        },
                        onAdd: () {},
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: SizedBox(
            height: 520,
            width: screenSize.width,
            child: Column(
              children: List.generate(
                4,
                (index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ShoppingCard(
                    isHorizontal: true,
                    productImage: 'images/apple.png',
                    productName: 'Apple',
                    category: 'Electronics',
                    price: 100,
                    discount: 10,
                    isFavourite: isFavourite,
                    onFavourite: () {
                      isFavourite = !isFavourite;
                      setState(() {});
                    },
                    onAdd: () {},
                    onTap: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget mainAppbar() {
    return AppBar(
      title: const Text(
        "Home",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      actions: [
        utilManager.customButton(
          width: 50,
          height: 50,
          borderRadius: 100,
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
          child: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
        ),
        utilManager.customButton(
          width: 50,
          height: 50,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userData.image ?? ""),
          ),
          borderRadius: 100,
          onTap: () {
            GoToPage().goToPage(context, page: const UserDetailsInput());
          },
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  PreferredSizeWidget searchAppBar(double width) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.75,
            child: utilManager.customTextField(
              labelText: "Search",
              hintText: "Fresh Apples",
              controller: searchController,
              hintColor: Colors.black54,
              labelColor: Colors.black54,
              fillColor: const Color.fromARGB(255, 253, 247, 247),
              enabledBorderColor: Colors.transparent,
              focusedColor: const Color.fromARGB(255, 50, 194, 122),
              prefixIcon: const Icon(
                Icons.search,
                size: 30,
                color: Color.fromARGB(255, 50, 194, 122),
              ),
            ),
          ),
          const SizedBox(width: 1),
          utilManager.customButton(
            width: 50,
            height: 50,
            color: const Color.fromARGB(255, 50, 194, 122),
            child: const Icon(
              Icons.filter_list_alt,
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }

  Widget userTitle() {
    return RichText(
      text: TextSpan(children: [
        const TextSpan(
          text: "Greetings\n",
          style: TextStyle(
            color: Colors.black38,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const TextSpan(
          text: "\n",
          style: TextStyle(
            color: Colors.black38,
            fontWeight: FontWeight.bold,
            fontSize: 5,
          ),
        ),
        TextSpan(
          text: userData.fullName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ]),
    );
  }
}
