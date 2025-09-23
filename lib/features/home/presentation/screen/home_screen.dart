import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_haven/core/assets/app_colors.dart';
import 'package:home_haven/features/carouselslider/presentation/screen/carousel_slider.dart';
import 'package:home_haven/features/product_details/screen/product_details_screen.dart';
import '../controller/home_controller.dart';
import '../../../home/model/home_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.fetchData();
          },
          color: Color(0xff156651),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffE0E0E0)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  controller.searchProduct(value);
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(12),
                                  border: InputBorder.none,
                                  hintText: "Search products...",
                                  prefixIcon: Icon(Icons.search_outlined),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CarouselSliderScreen(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Special Offers',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "See More",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff156651),
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xff156651),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => SizedBox(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.filterItem.length,
                            itemBuilder: (_, index) {
                              final item = controller.filterItem[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() =>
                                      ProductDetailsScreen(product: item));
                                },
                                child: Container(
                                  width: 170,
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2,
                                        ),
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Align(
                                            child: Image.network(
                                              item.image,
                                              width: 110,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 5,
                                            child: Container(
                                              width: 65,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: AppColors.red,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(14),
                                                  bottomRight:
                                                      Radius.circular(14),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  item.offPrice,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        item.offerPrice,
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(item.regularPrice),
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.amberAccent),
                                          Text(item.rating),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
