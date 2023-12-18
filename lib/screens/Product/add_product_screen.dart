import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maanecommerceui/custom_widgets/my_widgets.dart';
import 'package:maanecommerceui/models/product_model.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../../repos/get_product_repo.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, this.productIdLoc});

  final int? productIdLoc;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UtilManager utilManager = UtilManager();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productStockController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  File? selectedImageFile;
  String? networkImage;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).getProductData();
    List<ProductModel> products =
        Provider.of<ProductProvider>(context, listen: false).products;

    if (widget.productIdLoc != null) {
      ProductModel singleProduct = products
          .firstWhere((element) => element.productId == widget.productIdLoc);
      networkImage = singleProduct.productImage;
      productNameController.text = singleProduct.productName;
      productDescriptionController.text = singleProduct.productDescription;
      productStockController.text = singleProduct.productStock.toString();
      salePriceController.text = singleProduct.salePrice.toString();
      purchasePriceController.text = singleProduct.purchasePrice.toString();
      discountController.text = singleProduct.discount.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    productDescriptionController.dispose();
    productStockController.dispose();
    salePriceController.dispose();
    purchasePriceController.dispose();
    discountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: utilManager.customTextButton(
          buttonText: "Save Product Data",
          fontSize: 20,
          height: 50,
          width: screenSize.width,
          textColor: Colors.white,
          splashColor: Colors.white,
          color: _user != null
              ? const Color.fromARGB(255, 50, 194, 122)
              : Colors.black26,
          borderRadius: 80,
          onTap: _user != null
              ? () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final int productIDGen =
                        Timestamp.now().millisecondsSinceEpoch;
                    try {
                      String downloadUrl = "";
                      if (selectedImageFile != null) {
                        Reference storage = FirebaseStorage.instance.ref();
                        var snapshot = await storage
                            .child("Product Pictures/$productIDGen")
                            .putFile(selectedImageFile!);
                        downloadUrl = await snapshot.ref.getDownloadURL();
                      }
                      ProductModel data = ProductModel(
                        productImage: downloadUrl.isEmpty
                            ? (networkImage ?? "")
                            : downloadUrl,
                        productName: productNameController.text,
                        productDescription: productDescriptionController.text,
                        productId: productIDGen,
                        productStock:
                            int.tryParse(productStockController.text) ?? 0,
                        salePrice:
                            double.tryParse(salePriceController.text) ?? 0,
                        purchasePrice:
                            double.tryParse(purchasePriceController.text) ?? 0,
                        discount: double.tryParse(discountController.text) ?? 0,
                      );
                      postProductData(productModel: data);
                      EasyLoading.showSuccess("Product Data Updated");

                      selectedImageFile = null;
                      downloadUrl = "";
                      productNameController.clear();
                      productDescriptionController.clear();
                      productStockController.clear();
                      salePriceController.clear();
                      purchasePriceController.clear();discountController.clear();
                    } catch (e) {
                      EasyLoading.showError(e.toString());
                    }
                  }
                }
              : () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: screenSize.width,
          height: screenSize.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: userDetailsForm(screenSize: screenSize),
          ),
        ),
      ),
    );
  }

  Widget userDetailsForm({required Size screenSize}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          utilManager.customButton(
            width: 150,
            height: 150,
            color: const Color.fromARGB(255, 253, 247, 247),
            onTap: () async {
              selectedImageFile = await pickImage();
              setState(() {});
            },
            child: (networkImage ?? "").isNotEmpty
                ? Image.network(networkImage!)
                : selectedImageFile != null
                    ? Image.file(selectedImageFile!)
                    : const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.black54,
                      ),
          ),
          const SizedBox(height: 20),
          // Name Field
          utilManager.customTextField(
            labelText: "Product Name",
            hintText: "Potato",
            controller: productNameController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.abc_outlined),
            validator: _validateInput,
          ),
          const SizedBox(height: 10),
          utilManager.customTextField(
            labelText: "Product Description",
            hintText:
                "Very fresh potatoes! You will not find such fresh potatoes anywhere else in the market.",
            controller: productDescriptionController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.email_outlined),
            validator: _validateInput,
          ),
          const SizedBox(height: 10),
          utilManager.customTextField(
            labelText: "Items in stock(in kg)",
            hintText: "100",
            controller: productStockController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.location_on_outlined),
            validator: _validateInput,
          ),
          const SizedBox(height: 10),
          utilManager.customTextField(
            labelText: "Sale Price(tk)",
            hintText: "585",
            controller: salePriceController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.local_phone_outlined),
            validator: _validateInput,
          ),
          const SizedBox(height: 10),
          utilManager.customTextField(
            labelText: "Purchase Price(tk)",
            hintText: "550",
            controller: purchasePriceController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.landscape_outlined),
          ),
          const SizedBox(height: 10),
          utilManager.customTextField(
            labelText: "Discount(percent)",
            hintText: "20(It will be deducted from sale price)",
            controller: discountController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.zoom_out_map),
          ),
        ],
      ),
    );
  }

  Future<File?> pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image != null) {
        File imageFile = File(image.path);
        return imageFile;
      } else {
        return null;
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
    return null;
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }
}
