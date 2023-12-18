import 'package:flutter/material.dart';
import 'package:maanecommerceui/models/product_model.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:maanecommerceui/providers/profile_provider.dart';
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
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(favouritesList[index].productName),
                              const SizedBox(width: 20),
                              Text(
                                '${favouritesList[index].productStock}',
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          trailing: GestureDetector(
                            onTap: () async {
                              setState(() {
                                profile.changeFavourite(
                                    productID: favouritesList[index].productId);
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
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
