import 'package:flutter/material.dart';
import 'package:footwear_client/controller/home_controller.dart';
import 'package:footwear_client/pages/login_page.dart';
import 'package:footwear_client/pages/product_card.dart';
import 'package:footwear_client/pages/product_description_page.dart';
import 'package:footwear_client/widgets/drop_down_btn.dart';
import 'package:footwear_client/widgets/multi_select_drop_down.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:footwear_client/controller/category_controler.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Footwear Store',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                GetStorage box = GetStorage();
                box.erase();
                Get.offAll(() => LoginPage());
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Column(
          children: [
            GetBuilder<CategoryController>(
              builder: (controller) => SizedBox(
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Chip(
                          label: Text(
                            controller.categories[index].category ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DropDownBtn(
                    items: const ["Rs: Low to High", "Rs: High to Low"],
                    selectedItemsText: 'Sort by',
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: MultiSelectDropDown(onSelectedChanged: (value) {}),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 8,
                ),
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    productImage: controller.products[index].image ?? 'Url',
                    productName: controller.products[index].name ?? 'No name',
                    productPrice:
                        controller.products[index].price?.toString() ?? '0',
                    offerTag: '20% Off',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDescriptionPage(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
