import 'package:flutter/material.dart';
import 'package:maanecommerceui/custom_widgets/my_widgets.dart';
import 'package:maanecommerceui/models/cart_model.dart';
import 'package:maanecommerceui/models/product_model.dart';
import 'package:maanecommerceui/providers/cart_provider.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:maanecommerceui/screens/Product/add_product_screen.dart';
import 'package:maanecommerceui/screens/Product/view_product_details.dart';
import 'package:maanecommerceui/screens/Profile/get_user_data_screen.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/shopping_card.dart';
import '../../models/user_model.dart';
import '../../providers/profile_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late UserModel userData;
  late List<ProductModel> productData = [];
  UtilManager utilManager = UtilManager();
  TextEditingController searchController = TextEditingController();
  int pageIndex = 0;

  void _getData() {
    ProfileProvider userProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    userData = userProvider.user;
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productData.addAll(productProvider.products);
  }

  final List<Widget> bottomPages = [
    const Homepage(),
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

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).updateUserData();
    Provider.of<ProfileProvider>(context, listen: false).getFavouriteProducts();
    Provider.of<ProductProvider>(context, listen: false).getProductData();
    _getData();
  }

  Future<void> _onRefresh() async {
    Provider.of<ProfileProvider>(context, listen: false).updateUserData();
    Provider.of<ProfileProvider>(context, listen: false).getFavouriteProducts();
    Provider.of<ProductProvider>(context, listen: false).getProductData();
    _getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: NestedScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              List<ProductModel> searchedProducts = [];
              return [
                Consumer<ProductProvider>(builder: (context, products, child) {
                  /// -------------------- Search Results
                  return SliverAppBar(
                    title: const Text("Home"),
                    backgroundColor: Colors.white,
                    toolbarHeight: screenSize.height * 0.1,
                    floating: true,
                    pinned: true,
                    bottom: searchAppBar(
                      width: screenSize.width,
                      onChanged: (value) {
                        setState(() {});
                      },
                      onSearch: () {},
                    ),
                  );
                }),

                /// --------------------------------- Search Results
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    child: Consumer<ProductProvider>(
                        builder: (context, products, child) {
                      if (searchController.text.isNotEmpty) {
                        searchedProducts.addAll(
                          products.products.where(
                            (element) => element.productName
                                .toLowerCase()
                                .contains(searchController.text),
                          ),
                        );
                      } else {
                        searchedProducts = [];
                      }

                      /// -------------------- Search Results
                      return SizedBox(
                        height: searchedProducts.length < 4
                            ? searchedProducts.length * 80.0
                            : 4.0 * 80.0,
                        width: screenSize.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: List.generate(
                              searchedProducts.length > 4
                                  ? 4
                                  : searchedProducts.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Card(
                                  child: ListTile(
                                    onTap: () {
                                      Future.delayed(Duration.zero, () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewProductDetails(
                                              product: searchedProducts[index],
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                    title: Text(
                                      searchedProducts[index].productName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Text(
                                      searchedProducts[index]
                                          .salePrice
                                          .toString(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ];
            },
            body: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                children: [
                  /// --------------------------------- Products List
                  if (productData.isNotEmpty)
                    SizedBox(
                      height: 300,
                      width: screenSize.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Consumer2<ProductProvider, ProfileProvider>(
                            builder: (context, product, profile, child) {
                          Provider.of<ProfileProvider>(context, listen: false)
                              .getFavouriteProducts();
                          return ListView.builder(
                            itemCount: product.products.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ShoppingCard(
                                productImage:
                                    product.products[index].productImage,
                                productName:
                                    product.products[index].productName,
                                productStock:
                                    product.products[index].productStock,
                                description:
                                    product.products[index].productDescription,
                                isFavourite: profile.favourites.contains(
                                    product.products[index].productId),
                                price: product.products[index].salePrice,
                                discount: product.products[index].discount,
                                onFavourite: () {
                                  Provider.of<ProfileProvider>(context,
                                          listen: false)
                                      .changeFavourite(
                                          productID: product
                                              .products[index].productId);
                                },
                                onAdd: () {
                                  CartModel tempCart = CartModel(
                                    productId:
                                        product.products[index].productId,
                                    productStock:
                                        product.products[index].productStock,
                                    productName:
                                        product.products[index].productName,
                                    productImage:
                                        product.products[index].productImage,
                                    productDescription: product
                                        .products[index].productDescription,
                                    salePrice:
                                        product.products[index].salePrice,
                                    purchasePrice:
                                        product.products[index].purchasePrice,
                                    discount: product.products[index].discount,
                                    quantity: 1,
                                  );
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .addToCart(cartModel: tempCart);
                                },
                                onTap: () {
                                  Future.delayed(Duration.zero, () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewProductDetails(
                                          product: product.products[index],
                                        ),
                                      ),
                                    );
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                  /// -------------------------------- Discounted Product List
                  Consumer2<ProductProvider, ProfileProvider>(
                      builder: (context, product, profile, child) {
                    List<ProductModel> tempProducts = [];
                    List<ProductModel> sortedProducts = [];
                    tempProducts.addAll(
                      product.products.where((element) => element.discount > 0),
                    );
                    tempProducts
                        .sort((a, b) => a.discount.compareTo(b.discount));
                    sortedProducts.addAll(tempProducts.reversed);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: SizedBox(
                            width: screenSize.width,
                            height: 40,
                            child: const Text(
                              "Most Discounts!",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: sortedProducts.length <= 5
                              ? sortedProducts.length * 140.0
                              : 5.0 * 140.0,
                          width: screenSize.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: List.generate(
                                  sortedProducts.length <= 5
                                      ? sortedProducts.length
                                      : 5, (index) {
                                if (tempProducts[index].discount != 0) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ShoppingCard(
                                      isHorizontal: true,
                                      productImage:
                                          sortedProducts[index].productImage,
                                      productName:
                                          sortedProducts[index].productName,
                                      productStock:
                                          sortedProducts[index].productStock,
                                      description: sortedProducts[index]
                                          .productDescription,
                                      price: sortedProducts[index].salePrice,
                                      discount: sortedProducts[index].discount,
                                      isFavourite: profile.favourites.contains(
                                          sortedProducts[index].productId),
                                      onFavourite: () {
                                        profile.changeFavourite(
                                            productID: sortedProducts[index]
                                                .productId);
                                      },
                                      onAdd: () {
                                        CartModel tempCart;
                                        tempCart = CartModel(
                                          productId:
                                              sortedProducts[index].productId,
                                          productStock: sortedProducts[index]
                                              .productStock,
                                          productName:
                                              sortedProducts[index].productName,
                                          productImage: sortedProducts[index]
                                              .productImage,
                                          productDescription:
                                              sortedProducts[index]
                                                  .productDescription,
                                          salePrice:
                                              sortedProducts[index].salePrice,
                                          purchasePrice: sortedProducts[index]
                                              .purchasePrice,
                                          discount:
                                              sortedProducts[index].discount,
                                          quantity: 1,
                                        );
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .addToCart(cartModel: tempCart);
                                      },
                                      onTap: () {
                                        Future.delayed(Duration.zero, () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewProductDetails(
                                                product: sortedProducts[index],
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }),
                            ),
                          ),
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget searchAppBar({
    required double width,
    required Function() onSearch,
    required Function(String)? onChanged,
  }) {
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
              onChanged: onChanged,
              focusedColor: const Color.fromARGB(255, 50, 194, 122),
              suffixIcon: searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        searchController.text = "";
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.cancel_rounded,
                        size: 30,
                        color: Colors.black26,
                      ),
                    )
                  : null,
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
              Icons.search,
              color: Colors.white,
            ),
            onTap: onSearch,
          )
        ],
      ),
    );
  }

  Widget userTitle() {
    return Consumer<ProfileProvider>(
        builder: (context, value, _) => RichText(
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
                  text: value.user.fullName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ]),
            ));
  }
}
