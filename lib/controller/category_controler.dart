import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:footwear_client/models/category/product_category.dart';

class CategoryController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference categoryCollection;

  List<ProductCategory> categories = [];

  @override
  void onInit() {
    super.onInit();
    categoryCollection = firestore.collection('category');
    fetchCategories();
  }

  fetchCategories() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();
      List<ProductCategory> retrievedCategories = categorySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final name = (data['name'] ?? data['category'] ?? '')
                .toString()
                .trim();
            return ProductCategory(category: name, id: doc.id);
          })
          .where((c) => (c.category ?? '').isNotEmpty)
          .toList();

      // Fallback: if "categories" is empty or not filled, derive from products.
      if (retrievedCategories.isEmpty) {
        final productSnapshot = await firestore.collection('products').get();
        final uniqueNames =
            productSnapshot.docs
                .map((doc) {
                  final data = doc.data();
                  return (data['category'] ?? '').toString().trim();
                })
                .where((name) => name.isNotEmpty)
                .toSet()
                .toList()
              ..sort();
        retrievedCategories = uniqueNames
            .map((name) => ProductCategory(category: name, id: name))
            .toList();
      }

      categories.clear();
      categories.assignAll(retrievedCategories);

      Get.snackbar(
        "Success",
        "Categories fetched successfully",
        colorText: Colors.green,
        backgroundColor: Colors.green[100],
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error fetching categories: ${e.toString()}",
        colorText: Colors.red,
        backgroundColor: Colors.red[100],
      );
    } finally {
      update();
    }
  }
}
