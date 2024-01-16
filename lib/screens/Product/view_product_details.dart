import 'package:flutter/material.dart';
import 'package:maanecommerceui/custom_widgets/my_widgets.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../../models/cart_model.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';

class ViewProductDetails extends StatefulWidget {
  const ViewProductDetails({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  State<ViewProductDetails> createState() => _ViewProductDetailsState();
}

class _ViewProductDetailsState extends State<ViewProductDetails> {
  UtilManager um = UtilManager();

  bool isStockAvailable(ProductModel product) {
    if (product.productStock <= 0) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).getProductData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double discountPrice = widget.product.salePrice -
        (widget.product.salePrice * (widget.product.discount / 100));
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar:
          Consumer<ProductProvider>(builder: (context, products, child) {
        ProductModel thisProduct = widget.product;
        for (ProductModel product in products.products) {
          if (product.productId == widget.product.productId) {
            thisProduct = product;
          }
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: um.customButton(
              width: screenSize.width,
              color: isStockAvailable(thisProduct)
                  ? const Color.fromARGB(255, 50, 194, 122)
                  : Colors.grey,
              splashColor: isStockAvailable(thisProduct)
                  ? const Color.fromARGB(255, 132, 203, 164)
                  : Colors.grey,
              onTap: isStockAvailable(thisProduct)
                  ? () {
                      CartModel tempCart = CartModel(
                        productId: thisProduct.productId,
                        productStock: thisProduct.productStock,
                        productName: thisProduct.productName,
                        productImage: thisProduct.productImage,
                        productDescription: thisProduct.productDescription,
                        salePrice: thisProduct.salePrice,
                        purchasePrice: thisProduct.purchasePrice,
                        discount: thisProduct.discount,
                        quantity: 1,
                      );
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(cartModel: tempCart);
                    }
                  : () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 35,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Add to cart",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
        );
      }),
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: screenSize.width,
                height: screenSize.width,
                child: Image.network(widget.product.productImage),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                width: screenSize.width,
                height: 50,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    widget.product.productName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Container(
                width: screenSize.width,
                padding: const EdgeInsets.all(8.0),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///------------------------ Product Price
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 250,
                        height: 25,
                        child: RichText(
                          text: TextSpan(children: [
                            ///------------------------ Product Discount
                            TextSpan(
                              text: '৳${discountPrice.toStringAsFixed(2)} ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            if (widget.product.discount > 0)
                              TextSpan(
                                text:
                                    '৳${widget.product.salePrice.toStringAsFixed(2)} ',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  decoration: TextDecoration.lineThrough,
                                  overflow: TextOverflow.fade,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (widget.product.discount > 0)
                              TextSpan(
                                text:
                                    '  -${widget.product.discount.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  overflow: TextOverflow.fade,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ]),
                          maxLines: 2,
                        ),
                      ),
                    ),

                    ///------------------------ Product Rating
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 30,
                    ),
                    Text(
                      "${widget.product.rating ?? 0}/5",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 3),

              /// Product Description
              Container(
                color: Colors.black12,
                child: ExpansionTile(
                  title: const Text(
                    "Product Description",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  children: [
                    SizedBox(
                      width: screenSize.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        child: Text(
                          widget.product.productDescription,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
