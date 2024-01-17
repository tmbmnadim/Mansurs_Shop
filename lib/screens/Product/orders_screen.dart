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
  UtilManager um = UtilManager();

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
      body: SizedBox(
        height: screenSize.height * 0.8,
        child: Consumer<OrdersProvider>(builder: (context, order, child) {
          List<String> userIdList = [];
          List<double> userSubTotal = [];
          for (var element in order.orders) {
            if (userIdList.contains(element.userID)) {
              int index = userIdList.indexOf(element.userID);
              userSubTotal[index] = userSubTotal[index] +
                  ((element.salePrice -
                          (element.salePrice * (element.discount / 100))) *
                      element.quantity);
              continue;
            } else {
              userSubTotal.add((element.salePrice -
                      (element.salePrice * (element.discount / 100))) *
                  element.quantity);
              userIdList.add(element.userID);
            }
          }

          return order.orders.isEmpty
              ? const Center(child: Text('There are no Orders yet!'))
              : ListView.builder(
                  itemCount: order.userList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: const Color.fromARGB(255, 50, 194, 122),
                        child: ExpansionTile(
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide.none,
                          ),

                          ///----------------------------------Index
                          leading: SizedBox(
                            width: 10,
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          ///----------------------------------User ID
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 140,
                                height: 40,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    order.orders[index].userID,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),

                              ///----------------------------------Order Count
                              Text(
                                "${order.userOrders[index].length}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          ///----------------------------------Total Order Price
                          subtitle: Text(
                            "Total Cost: ${userSubTotal[index]}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),

                          ///----------------------------------Orders List
                          children: List.generate(
                            order.userOrders[index].length + 1,
                            (perUser) {
                              if (perUser < order.userOrders[index].length) {
                                return Card(
                                  color:
                                      const Color.fromARGB(255, 253, 247, 247),
                                  child: ListTile(
                                    title: Text(
                                      order.userOrders[index][perUser]
                                          .productName,
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
                                          amount: order
                                              .userOrders[index][perUser]
                                              .quantity,
                                          addOrRemove: "add",
                                        );
                                        order.deleteOrder(
                                            orderModel: order.userOrders[index]
                                                [perUser]);
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
                                              "${(order.userOrders[index][perUser].salePrice - (order.userOrders[index][perUser].salePrice * (order.userOrders[index][perUser].discount / 100)))} x ${order.userOrders[index][perUser].quantity}"),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const SizedBox(width: 20),
                                        Text(
                                          ' = ${order.userOrders[index][perUser].quantity * (order.userOrders[index][perUser].salePrice - (order.userOrders[index][perUser].salePrice * (order.userOrders[index][perUser].discount / 100)))}',
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: SizedBox(
                                    width: screenSize.width,
                                    height: 70,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        um.customButton(
                                          color: Colors.white,
                                          width: screenSize.width * 0.4,
                                          onTap: () {
                                            order.deleteUserOrders(
                                              userId: userIdList[index],
                                            );
                                          },
                                          child: const Text(
                                            "Send Orders\nfor Delivery",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 50, 194, 122),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),

                                        /// -----------Delete ALl Orders Button
                                        um.customButton(
                                          color: Colors.white,
                                          width: screenSize.width * 0.4,
                                          onTap: () {
                                            order.deleteUserOrders(
                                              userId: userIdList[index],
                                            );
                                          },
                                          child: const Text(
                                            "Delete All Orders",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
        }),
      ),
    );
  }
}
