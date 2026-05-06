import 'package:flutter/material.dart';
import 'package:footwear_client/models/product/product.dart';
import 'package:get/get.dart';

class ProductDescriptionPage extends StatelessWidget {
  const ProductDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final Product? product =
        args is Map<String, dynamic> ? args['data'] as Product? : null;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Product Details'), centerTitle: true),
        body: Center(child: Text('Product data is unavailable')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Product Details'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.image ?? 'Url',
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 20),
            Text(
              product.name ?? 'No name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              product.description ?? 'No description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Text(
              product.price?.toString() ?? '0',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Enter your Billing Address',
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text('Buy Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
