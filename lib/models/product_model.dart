class ProductModel {
  late int productId, productStock;
  int? rating;
  late String productName, productImage, productDescription;
  String? review;
  late double salePrice, purchasePrice, discount;
  String? databaseKey;

  ProductModel({
    required this.productId,
    required this.productStock,
    required this.productName,
    required this.productImage,
    required this.productDescription,
    required this.salePrice,
    required this.purchasePrice,
    required this.discount,
    this.review,
    this.rating,
    this.databaseKey,
  });

  ProductModel.fromJson({required Map<String, dynamic> json}) {
    productId = json['productId'];
    productStock = json['productStock'];
    rating = json['rating'];
    productName = json['productName'];
    productImage = json['productImage'];
    productDescription = json['productDescription'];
    review = json['review'];
    salePrice = json['salePrice'];
    purchasePrice = json['purchasePrice'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'productId': productId,
    'productStock': productStock,
    'rating': rating,
    'productName': productName,
    'productImage': productImage,
    'productDescription': productDescription,
    'review': review,
    'salePrice': salePrice,
    'purchasePrice': purchasePrice,
    'discount': discount,
  };
}
