import 'package:flutter/material.dart';
import 'package:maanecommerceui/models/product_model.dart';
import 'package:maanecommerceui/providers/cart_provider.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:provider/provider.dart';

class UserCartScreen extends StatefulWidget {
  const UserCartScreen({super.key});

  @override
  State<UserCartScreen> createState() => _UserCartScreenState();
}

class _UserCartScreenState extends State<UserCartScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).getAllCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      bottomNavigationBar:
          Consumer<CartProvider>(builder: (context, cart, child) {
        return Container(
          height: 60,
          decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              )),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 20),
              Text(
                'SubTotal: ${cart.subtotal}',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    backgroundColor: const Color.fromARGB(255, 50, 194, 122),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    for (var singleItem in cart.cartItems) {
                      ProductModel? product =
                          await Provider.of<ProductProvider>(context,
                                  listen: false)
                              .getSingleProductData(
                                  productId: singleItem.productId);
                      int stockIs = product?.productStock ?? 0;
                      if (stockIs == 0) {
                        cart.removeFromCart(cartModel: singleItem);
                      }
                    }
                    Future.delayed(Duration.zero, () {
                      if (cart.cartItems.isNotEmpty) cart.sentAsOrders(context);
                    });
                    // cart.clearCart();
                  },
                  child: const Text(
                    'Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 1),
            ],
          )),
        );
      }),
      body: Consumer<CartProvider>(builder: (context, cart, child) {
        return cart.cartItems.isEmpty
            ? const Center(child: Text('Cart is Empty'))
            : ListView.builder(
                itemCount: cart.cartItems.length,
                itemBuilder: (context, index) {
                  return Card(
                      color: const Color.fromARGB(255, 253, 247, 247),
                      child: ListTile(
                        title: Text(cart.cartItems[index].productName),
                        trailing: GestureDetector(
                          onTap: () {
                            cart.removeFromCart(
                                cartModel: cart.cartItems[index]);
                            cart.calculateSubtotal();
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                cart.subQuantity(index: index);
                              },
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor:
                                    Color.fromARGB(255, 50, 194, 122),
                                child: Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                            // IconButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),onPressed: () {}, icon: const Icon(Icons.remove)),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(cart.cartItems[index].quantity.toString()),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                cart.addQuantity(index: index);
                              },
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor:
                                    Color.fromARGB(255, 50, 194, 122),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              'X ${(cart.cartItems[index].salePrice - (cart.cartItems[index].salePrice * (cart.cartItems[index].discount / 100)))} = ${cart.cartItems[index].quantity * cart.cartItems[index].salePrice - (cart.cartItems[index].salePrice * (cart.cartItems[index].discount / 100))}',
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 20),
                            )
                          ],
                        ),
                      ));
                },
              );
      }),
    );
  }
}
