class CartModel {
  late int productId, productStock, quantity;
  int? rating;
  late String productName, productImage, productDescription;
  late double salePrice, purchasePrice, discount;
  String? databaseKey, review;

  CartModel({
    required this.productId,
    required this.productStock,
    required this.productName,
    required this.productImage,
    required this.productDescription,
    required this.salePrice,
    required this.purchasePrice,
    required this.discount,
    required this.quantity,
    this.review,
    this.rating,
    this.databaseKey,
  });



  CartModel.fromJson({required Map<String, dynamic> json}) {
    productId = json['productId'];
    quantity = json['quantity'];
    productStock = json['productStock'];
    productName = json['productName'];
    productImage = json['productImage'];
    productDescription = json['productDescription'];
    salePrice = json['salePrice'];
    purchasePrice = json['purchasePrice'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'productId': productId,
    'quantity': quantity,
    'productStock': productStock,
    'productName': productName,
    'productImage': productImage,
    'productDescription': productDescription,
    'salePrice': salePrice,
    'purchasePrice': purchasePrice,
    'discount': discount,
  };
}
