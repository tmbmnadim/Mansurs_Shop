import 'package:flutter/material.dart';
import 'package:maanecommerceui/models/product_model.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:maanecommerceui/providers/profile_provider.dart';
import 'package:maanecommerceui/screens/Product/view_product_details.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).updateUserData();
    Provider.of<ProfileProvider>(context, listen: false).getFavouriteProducts();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites"),
      ),
      body: SizedBox(
        width: screenSize.width,
        height: screenSize.height * 0.95,
        child: Consumer2<ProductProvider, ProfileProvider>(
          builder: (context, product, profile, child) {
            List<ProductModel> favouritesList = [];
            for (var element in product.products) {
              if (profile.favourites.contains(element.productId)) {
                favouritesList.add(element);
              }
            }
            return favouritesList.isEmpty
                ? const Center(
                    child: Text("No Favourite items added!"),
                  )
                : ListView.builder(
                    itemCount: favouritesList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color.fromARGB(255, 50, 194, 122),
                        child: Stack(
                          children: [
                            ListTile(
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewProductDetails(
                                        product: favouritesList[index],
                                      ),
                                    ),
                                  );
                                });
                              },
                              title: SizedBox(
                                height: 40,
                                child: Text(
                                  favouritesList[index].productName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  const Text(
                                    'Product On Stock: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${favouritesList[index].productStock}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  profile.changeFavourite(
                                    productID: favouritesList[index].productId,
                                  );
                                },
                                child: Container(
                                  width: 80,
                                  height: 82,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
