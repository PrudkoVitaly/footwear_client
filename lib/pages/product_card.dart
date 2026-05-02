import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String productImage;
  final String productName;
  final String productPrice;
  final String offerTag;
  final Function() onTap;

  const ProductCard({
    super.key,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.offerTag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage =
        productImage.startsWith('http://') || productImage.startsWith('https://');

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isNetworkImage
                  ? Image.network(
                      productImage,
                      fit: BoxFit.cover,
                      height: 120,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 120,
                          child: Center(child: Icon(Icons.broken_image)),
                        );
                      },
                    )
                  : Image.asset(
                      productImage,
                      fit: BoxFit.cover,
                      height: 120,
                      width: double.infinity,
                    ),
              SizedBox(height: 10),
              Text(
                productName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 10),
              Text(
                productPrice,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  offerTag,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
