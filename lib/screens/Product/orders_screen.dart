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
                        child: ExpansionTile(
                          ///----------------------------------Index
                          leading: SizedBox(
                            width: 10,
                            child: Text("${index + 1}"),
                          ),

                          ///----------------------------------User ID
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 140,
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

                              ///----------------------------------Order Count
                              Row(
                                children: [
                                  Text(
                                    "${order.userOrders[index].length}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Text("${userSubTotal[index]}"),
                          children: List.generate(
                            order.userOrders[index].length,
                            (perUser) => Card(
                              color: const Color.fromARGB(255, 253, 247, 247),
                              child: ListTile(
                                title: Text(
                                  order.userOrders[index][perUser].productName,
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    changeProductStock(
                                      productId: order
                                          .userOrders[index][perUser].productId,
                                      productStock: order
                                          .userOrders[index][perUser]
                                          .productStock,
                                      amount: order
                                          .userOrders[index][perUser].quantity,
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
                            ),
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
