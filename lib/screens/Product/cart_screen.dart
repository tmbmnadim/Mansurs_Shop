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
                      color: const Color.fromARGB(255, 50, 194, 122),
                      child: Stack(
                        children: [
                          ListTile(
                            /// --------------------------------Name of Product
                            title: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                cart.cartItems[index].productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            /// -------------------------------- Quantity Buttons
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  /// -------------------------- Reduce Quantity
                                  GestureDetector(
                                    onTap: () {
                                      cart.subQuantity(index: index);
                                    },
                                    child: const CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // IconButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),onPressed: () {}, icon: const Icon(Icons.remove)),
                                  const SizedBox(
                                    width: 10,
                                  ),

                                  /// -------------------------- Product Quantity
                                  Text(
                                    cart.cartItems[index].quantity.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),

                                  /// -------------------------- Add to Quantity
                                  GestureDetector(
                                    onTap: () {
                                      cart.addQuantity(index: index);
                                    },
                                    child: const CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),

                                  /// --------------------------------- Subtotal
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'X ${(cart.cartItems[index].salePrice - (cart.cartItems[index].salePrice * (cart.cartItems[index].discount / 100)))}',
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 20),
                                        ),
                                        TextSpan(
                                          text:
                                              ' = ${cart.cartItems[index].quantity * cart.cartItems[index].salePrice - (cart.cartItems[index].salePrice * (cart.cartItems[index].discount / 100))}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                cart.removeFromCart(
                                    cartModel: cart.cartItems[index]);
                                cart.calculateSubtotal();
                              },
                              child: Container(
                                width: 80,
                                height: 100,
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
                      ));
                },
              );
      }),
    );
  }
}
