import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footwear_client/models/category/product_category.dart';
import 'package:footwear_client/models/product/product.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  List<Product> allProducts = [];
  List<Product> products = [];
  List<Product> productShowInUi = [];
  List<ProductCategory> productCategories = [];
  String selectedCategory = 'All';
  List<String> selectedBrands = [];

  @override
  void onInit() async {
    super.onInit();
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('category');
    await fetchProducts();
    await fetchCategories();
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      allProducts.clear();
      allProducts.assignAll(retrievedProducts);
      _applyFilters();
      // Get.snackbar(
      //   "Success",
      //   "Products fetched successfully",
      //   colorText: Colors.green,
      //   backgroundColor: Colors.green[100],
      // );
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

  fetchCategories() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();
      final List<ProductCategory> retrievedCategories = categorySnapshot.docs
          .map(
            (doc) =>
                ProductCategory.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
      productCategories.clear();
      productCategories.assignAll(retrievedCategories);
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

  filterByCategory(String category) {
    selectedCategory = category.trim().isEmpty ? 'All' : category;
    _applyFilters();
  }

  filterByBrand(List<String> brands) {
    selectedBrands = brands.where((brand) => brand.trim().isNotEmpty).toList();
    _applyFilters();
  }

  void _applyFilters() {
    Iterable<Product> filtered = allProducts;

    final normalizedCategory = selectedCategory.trim().toLowerCase();
    if (normalizedCategory.isNotEmpty && normalizedCategory != 'all') {
      filtered = filtered.where((product) {
        final productCategory = (product.category ?? '').trim().toLowerCase();
        return productCategory == normalizedCategory;
      });
    }

    if (selectedBrands.isNotEmpty) {
      final lowerCaseBrands = selectedBrands
          .map((brand) => brand.trim().toLowerCase())
          .toSet();
      filtered = filtered.where((product) {
        final brand = (product.brand ?? '').trim().toLowerCase();
        return lowerCaseBrands.contains(brand);
      });
    }

    products = filtered.toList();
    productShowInUi = List<Product>.from(products);
    update();
  }

  sortByPrice({required bool ascending}) {
    List<Product> sortedProducts = List<Product>.from(productShowInUi);
    sortedProducts.sort(
      (a, b) {
        final aPrice = a.price;
        final bPrice = b.price;

        if (aPrice == null && bPrice == null) return 0;
        if (aPrice == null) return 1;
        if (bPrice == null) return -1;

        return ascending ? aPrice.compareTo(bPrice) : bPrice.compareTo(aPrice);
      },
    );
    productShowInUi = sortedProducts;
    update();
  }
}
