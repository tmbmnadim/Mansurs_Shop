import 'package:flutter/material.dart';

class ShoppingCard extends StatelessWidget {
  final String productImage;
  final String productName;
  final String description;
  final double price;
  final bool isFavourite;
  final Function() onFavourite;
  final Function() onAdd;
  final Function() onTap;
  final double discount;
  final bool isHorizontal;

  const ShoppingCard({
    super.key,
    required this.productImage,
    required this.productName,
    required this.description,
    required this.price,
    this.isFavourite = false,
    required this.onFavourite,
    required this.onAdd,
    required this.onTap,
    this.discount = 0.0,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    double discountPrice = price - (price * (discount / 100));
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isHorizontal ? 380 : 200,
        height: isHorizontal ? 120 : 200,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 253, 247, 247),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: [
            ColumnOrRow(
              isHorizontal: isHorizontal,
              children: [
                // Image Container <-----------------
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Image.network(
                      productImage,
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 110,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        // Product title and Category <--------------
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              productName,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            // Product Price <-------------------------
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 128,
                              height: 40,
                              child: RichText(
                                text: TextSpan(children: [
                                  if (discount > 0)
                                    TextSpan(
                                      text: '৳${price.toStringAsFixed(2)}\n',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough,
                                        overflow: TextOverflow.fade,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  TextSpan(
                                    text:
                                        '৳${discountPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                                maxLines: 2,
                              ),
                            ),
                          ),
                          GestureDetector(
                            // Add Button <-----------------------
                            onTap: onAdd,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 50, 194, 122),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (discount > 0)
              Positioned(
                top: -8,
                left: -8,
                child: Container(
                  // DISCOUNT CONTAINER <------------
                  alignment: Alignment.center,
                  width: 80,
                  height: 30,
                  margin: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 242, 153, 21),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.zero,
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${discount.toInt()}% OFF',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 4.0,
              right: 4.0,
              child: IconButton(
                icon: Icon(
                  isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: isFavourite ? Colors.red : Colors.black,
                ),
                onPressed: onFavourite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ColumnOrRow extends StatelessWidget {
  final List<Widget> children;
  final bool isHorizontal;
  const ColumnOrRow({
    super.key,
    required this.children,
    required this.isHorizontal,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }
  }
}
