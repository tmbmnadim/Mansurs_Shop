import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maanecommerceui/custom_widgets/my_widgets.dart';
import 'package:maanecommerceui/repos/get_product_repo.dart';
import 'package:provider/provider.dart';

import '../../providers/orders_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  TextEditingController searchController = TextEditingController();
  UtilManager utilManager = UtilManager();

  @override
  void initState() {
    super.initState();
    Provider.of<OrdersProvider>(context, listen: false).getOrderData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      // bottomNavigationBar:
      // Consumer<OrdersProvider>(builder: (context, value, child) {
      //   return Container(
      //     height: 60,
      //     decoration: const BoxDecoration(
      //         color: Colors.black54,
      //         borderRadius: BorderRadius.vertical(
      //           top: Radius.circular(25),
      //         )),
      //     child: Center(
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             const SizedBox(width: 20),
      //             Text(
      //               'SubTotal: ${value.subtotal}',
      //               style: const TextStyle(fontSize: 20, color: Colors.white),
      //             ),
      //             ElevatedButton(
      //               style: ElevatedButton.styleFrom(
      //                 padding: const EdgeInsets.symmetric(
      //                   horizontal: 30,
      //                   vertical: 20,
      //                 ),
      //                 backgroundColor: const Color.fromARGB(255, 50, 194, 122),
      //                 elevation: 0,
      //               ),
      //               onPressed: () {
      //                 EasyLoading.showSuccess(
      //                     'Order Placed!\nPrice: ${value.subtotal}');
      //                 value.clearCart();
      //               },
      //               child: const Text('CheckOut'),
      //             ),
      //             const SizedBox(width: 1),
      //           ],
      //         )),
      //   );
      // }),
      body: SizedBox(
        height: screenSize.height * 0.8,
        child: Consumer<OrdersProvider>(builder: (context, value, child) {
          List<String> userIdList = [];
          for (var element in value.orders) {
            if (userIdList.contains(element.userID)) {
              continue;
            } else {
              userIdList.add(element.userID);
            }
          }

          /// DON"T FORGET TO CHANGE THIS TO .isEmpty
          return value.orders.isEmpty
              ? const Center(child: Text('There are no Orders yet!'))
              : Consumer<OrdersProvider>(builder: (context, order, child) {
                  return ListView.builder(
                    itemCount: order.userList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ExpansionTile(
                            leading: SizedBox(
                              width: 70,
                              child: Text("$index"),
                            ),
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    order.orders[index].userID,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${order.userOrders[index].length}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            subtitle: const Text("Total Price"),
                            children: List.generate(
                              order.userOrders[index].length,
                              (perUser) => Card(
                                color: const Color.fromARGB(255, 253, 247, 247),
                                child: ListTile(
                                  title: Text(
                                    order
                                        .userOrders[index][perUser].productName,
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      changeProductStock(
                                        productId: order
                                            .userOrders[index][perUser]
                                            .productId,
                                        productStock: order
                                            .userOrders[index][perUser]
                                            .productStock,
                                        amount: order.userOrders[index][perUser]
                                            .quantity,
                                        addOrRemove: "add",
                                      );
                                      order.deleteOrder(
                                          orderModel: order.userOrders[index]
                                              [perUser]);
                                      Provider.of<OrdersProvider>(context,
                                              listen: false)
                                          .getOrderData();
                                      EasyLoading.showSuccess(
                                        "Deleted Product",
                                      );
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                            "${order.userOrders[index][perUser].salePrice} x ${order.userOrders[index][perUser].quantity}"),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        ' = ${order.userOrders[index][perUser].quantity * order.userOrders[index][perUser].salePrice}',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                });
        }),
      ),
    );
  }
}
