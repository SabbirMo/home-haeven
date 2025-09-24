import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_haven/core/assets/app_colors.dart';
import 'package:home_haven/features/carouselslider/presentation/screen/carousel_slider.dart';
import 'package:home_haven/features/product_details/screen/product_details_screen.dart';
import 'package:home_haven/features/cart/controller/cart_controller.dart';
import 'package:home_haven/features/wishlist/controller/wishlist_controller.dart';
import 'package:home_haven/features/products/screen/all_products_screen.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    // Ensure WishlistController is initialized
    Get.put(WishlistController());

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
                      const SizedBox(height: 10),
                      CarouselSliderScreen(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Popular Products',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => AllProductsScreen());
                            },
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
                          height: 307,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.filterItem.length,
                            itemBuilder: (_, index) {
                              final item = controller.filterItem[index];
                              return Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => ProductDetailsScreen(
                                            product: item));
                                      },
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
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(14),
                                                      bottomRight:
                                                          Radius.circular(14),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      item.offPrice
                                                          .replaceAll('"', ''),
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
                                            item.title.replaceAll('"', ''),
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            '৳${item.offerPrice.replaceAll('"', '')}',
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          if (item.regularPrice !=
                                                  item.offerPrice &&
                                              item.regularPrice.isNotEmpty)
                                            Text(
                                              '৳${item.regularPrice.replaceAll('"', '')}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          Row(
                                            children: [
                                              Icon(Icons.star,
                                                  color: Colors.amberAccent),
                                              Text(item.rating
                                                  .replaceAll('"', '')),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Action Buttons Row
                                    Row(
                                      children: [
                                        // Wishlist Button
                                        Expanded(
                                          child: GetBuilder<WishlistController>(
                                            init: WishlistController(),
                                            builder: (wishlistController) {
                                              bool isWishlisted =
                                                  wishlistController
                                                      .isInWishlist(item.id);
                                              return GestureDetector(
                                                onTap: () {
                                                  wishlistController
                                                      .toggleWishlist(item);
                                                },
                                                child: Container(
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: isWishlisted
                                                        ? AppColors.red
                                                            .withOpacity(0.1)
                                                        : Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: isWishlisted
                                                          ? AppColors.red
                                                          : Colors.grey[300]!,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      isWishlisted
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: isWishlisted
                                                          ? AppColors.red
                                                          : Colors.grey[600],
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        // Add to Cart Button
                                        Expanded(
                                          flex: 2,
                                          child: GetBuilder<CartController>(
                                            init: CartController(),
                                            builder: (cartController) {
                                              bool isInCart = cartController
                                                  .isInCart(item.id);

                                              return GestureDetector(
                                                onTap: () {
                                                  if (!isInCart) {
                                                    cartController.addToCart(
                                                        item, 'Default');
                                                  }
                                                },
                                                child: Container(
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: isInCart
                                                        ? Colors.green
                                                        : AppColors.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          isInCart
                                                              ? Icons.check
                                                              : Icons
                                                                  .shopping_cart_outlined,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          isInCart
                                                              ? 'Added'
                                                              : 'Add',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Categories Section
                      _buildCategoriesSection(),
                      const SizedBox(height: 24),
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

  Widget _buildCategoriesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Outdoor Category
            Expanded(
              child: _buildCategoryCard(
                title: 'Outdoor',
                iconPath: 'assets/icons/grill.png',
                backgroundColor: Color(0xFFE0F0E3),
                onTap: () {
                  // Navigate to outdoor products
                  Get.to(() => AllProductsScreen());
                },
              ),
            ),
            const SizedBox(width: 12),
            // Appliances Category
            Expanded(
              child: _buildCategoryCard(
                title: 'Appliances',
                iconPath: 'assets/icons/electrical.png',
                backgroundColor: Color(0xFFDEEBFF),
                onTap: () {
                  // Navigate to appliances
                  Get.to(() => AllProductsScreen());
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Furniture Category
            Expanded(
              child: _buildCategoryCard(
                title: 'Furniture',
                iconPath: 'assets/icons/sofa.png',
                backgroundColor: Color(0xFFFFEBC2),
                onTap: () {
                  // Navigate to furniture
                  Get.to(() => AllProductsScreen());
                },
              ),
            ),
            const SizedBox(width: 12),
            // See More Category
            Expanded(
              child: _buildCategoryCard(
                title: 'See More',
                iconPath: 'assets/icons/more-icon.png',
                backgroundColor: Color(0xFFEEEEEE),
                onTap: () {
                  // Navigate to all categories
                  Get.to(() => AllProductsScreen());
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String iconPath,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
