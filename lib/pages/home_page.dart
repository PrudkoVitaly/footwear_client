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
      builder: (controller) {
        final brandItems = controller.allProducts
            .map((product) => (product.brand ?? '').trim())
            .where((brand) => brand.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchProducts();
          },
          child: Scaffold(
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
                builder: (categoryController) => SizedBox(
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryController.categories.length + 1,
                      itemBuilder: (context, index) {
                        final categoryName = index == 0
                            ? 'All'
                            : (categoryController
                                      .categories[index - 1]
                                      .category ??
                                  '');
                        return InkWell(
                          onTap: () {
                            controller.filterByCategory(categoryName);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                            ),
                            child: Chip(label: Text(categoryName)),
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
                    flex: 2,
                    child: DropDownBtn(
                      items: const ["Rs: Low to High", "Rs: High to Low"],
                      selectedItemsText: 'Sort by',
                      onChanged: (value) {},
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: MultiSelectDropDown(
                      items: brandItems,
                      onSelectedChanged: (value) {
                        controller.filterByBrand(value);
                      },
                    ),
                  ),
                ],
              ),
              if (controller.selectedBrands.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6.0,
                  ),
                  child: SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: controller.selectedBrands
                          .map(
                            (brand) => Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Chip(label: Text(brand)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
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
      },
    );
  }
}
