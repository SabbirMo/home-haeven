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
                      const SizedBox(height: 16),
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
                          height: 320,
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() =>
                                              ProductDetailsScreen(product: item));
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                                        item.offPrice.replaceAll('"', ''),
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
                                            if (item.regularPrice != item.offerPrice && item.regularPrice.isNotEmpty)
                                              Text(
                                                '৳${item.regularPrice.replaceAll('"', '')}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                            Row(
                                              children: [
                                                Icon(Icons.star,
                                                    color: Colors.amberAccent),
                                                Text(item.rating.replaceAll('"', '')),
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
                                                bool isWishlisted = wishlistController.isInWishlist(item.id);
                                                return GestureDetector(
                                                  onTap: () {
                                                    wishlistController.toggleWishlist(item);
                                                  },
                                                child: Container(
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: isWishlisted ? AppColors.red.withOpacity(0.1) : Colors.grey[100],
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: isWishlisted ? AppColors.red : Colors.grey[300]!,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                                                      color: isWishlisted ? AppColors.red : Colors.grey[600],
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
                                                bool isInCart = cartController.isInCart(item.id);
                                                
                                                return GestureDetector(
                                                onTap: () {
                                                  if (!isInCart) {
                                                    cartController.addToCart(item, 'Default');
                                                  }
                                                },
                                                child: Container(
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: isInCart ? Colors.green : AppColors.primary,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          isInCart ? Icons.check : Icons.shopping_cart_outlined,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          isInCart ? 'Added' : 'Add',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w600,
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
                      
                      // All Products Section
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'All Products',
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
                      const SizedBox(height: 16),
                      
                      // All Products Grid
                      Obx(
                        () => GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.68,
                          ),
                          itemCount: controller.filterItem.length > 6 ? 6 : controller.filterItem.length,
                          itemBuilder: (context, index) {
                            final item = controller.filterItem[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Image with Discount Badge
                                  Expanded(
                                    flex: 3,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => ProductDetailsScreen(product: item));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                              child: Image.network(
                                                item.image,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[200],
                                                    child: Icon(Icons.chair, color: Colors.grey[400], size: 50),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Discount Badge
                                        if (item.offPrice.isNotEmpty)
                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.red,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                item.offPrice.replaceAll('"', ''),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Product Details
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Product Name
                                          Text(
                                            item.title.replaceAll('"', ''),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 2),
                                          
                                          // Price Section
                                          Row(
                                            children: [
                                              Text(
                                                '৳${item.offerPrice.replaceAll('"', '')}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              if (item.regularPrice != item.offerPrice && item.regularPrice.isNotEmpty) ...[
                                                SizedBox(width: 3),
                                                Flexible(
                                                  child: Text(
                                                    '৳${item.regularPrice.replaceAll('"', '')}',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey[600],
                                                      decoration: TextDecoration.lineThrough,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          
                                          // Rating
                                          Row(
                                            children: [
                                              Icon(Icons.star, color: Colors.amber, size: 14),
                                              SizedBox(width: 1),
                                              Text(
                                                item.rating.replaceAll('"', ''),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          
                                          Spacer(),
                                          
                                          // Action Buttons
                                          Row(
                                            children: [
                                              // Wishlist Button
                                              Expanded(
                                                child: GetBuilder<WishlistController>(
                                                  builder: (wishlistController) {
                                                    bool isWishlisted = wishlistController.isInWishlist(item.id);
                                                    return GestureDetector(
                                                      onTap: () {
                                                        wishlistController.toggleWishlist(item);
                                                      },
                                                      child: Container(
                                                        height: 26,
                                                        decoration: BoxDecoration(
                                                          color: isWishlisted ? AppColors.red.withOpacity(0.1) : Colors.grey[100],
                                                          borderRadius: BorderRadius.circular(6),
                                                          border: Border.all(
                                                            color: isWishlisted ? AppColors.red : Colors.grey[300]!,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                                                            color: isWishlisted ? AppColors.red : Colors.grey[600],
                                                            size: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              // Add to Cart Button
                                              Expanded(
                                                flex: 2,
                                                child: GetBuilder<CartController>(
                                                  builder: (cartController) {
                                                    bool isInCart = cartController.isInCart(item.id);
                                                    
                                                    return GestureDetector(
                                                      onTap: () {
                                                        if (!isInCart) {
                                                          cartController.addToCart(item, 'Default');
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 26,
                                                        decoration: BoxDecoration(
                                                          color: isInCart ? Colors.green : AppColors.primary,
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Icon(
                                                                isInCart ? Icons.check : Icons.shopping_cart_outlined,
                                                                color: Colors.white,
                                                                size: 12,
                                                              ),
                                                              SizedBox(width: 2),
                                                              Flexible(
                                                                child: Text(
                                                                  isInCart ? 'Added' : 'Add',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                  overflow: TextOverflow.ellipsis,
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
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
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
