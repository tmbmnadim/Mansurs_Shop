import 'package:flutter/material.dart';
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
                  onPressed: () {
                    cart.sentAsOrders();
                    Provider.of<ProductProvider>(context, listen: false)
                        .orderedProduct(cartItems: cart.cartItems);
                    cart.clearCart();
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
      body: Consumer<CartProvider>(builder: (context, value, child) {
        return value.cartItems.isEmpty
            ? const Center(child: Text('Cart is Empty'))
            : ListView.builder(
                itemCount: value.cartItems.length,
                itemBuilder: (context, index) {
                  return Card(
                      color: const Color.fromARGB(255, 253, 247, 247),
                      child: ListTile(
                        title: Text(value.cartItems[index].productName),
                        trailing: GestureDetector(
                          onTap: () {
                            value.removeFromCart(
                                cartModel: value.cartItems[index]);
                            value.calculateSubtotal();
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
                                value.subQuantity(index: index);
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
                            Text(value.cartItems[index].quantity.toString()),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                value.addQuantity(index: index);
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
                              'X ${value.cartItems[index].salePrice} = ${value.cartItems[index].quantity * value.cartItems[index].salePrice}',
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
