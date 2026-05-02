import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footwear_client/models/product/product.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;

  List<Product> products = [];

  @override
  void onInit() async {
    super.onInit();
    productCollection = firestore.collection('products');
    await fetchProducts();
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      products.clear();
      products.assignAll(retrievedProducts);
      Get.snackbar(
        "Success",
        "Products fetched successfully",
        colorText: Colors.green,
        backgroundColor: Colors.green[100],
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error fetching products: ${e.toString()}",
        colorText: Colors.red,
        backgroundColor: Colors.red[100],
      );
    } finally {
      update();
    }
  }
}
