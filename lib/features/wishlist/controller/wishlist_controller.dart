import 'package:get/get.dart';
import 'package:home_haven/features/home/model/home_model.dart';

class WishlistController extends GetxController {
  var wishlistItems = <HomeModel>[].obs;
  
  // Get total wishlist items count
  int get itemCount => wishlistItems.length;
  
  // Check if item is in wishlist
  bool isInWishlist(String productId) {
    return wishlistItems.any((item) => item.id == productId);
  }
  
  // Add item to wishlist
  void addToWishlist(HomeModel product) {
    if (!isInWishlist(product.id)) {
      wishlistItems.add(product);
      Get.snackbar(
        'Added to Wishlist',
        '${product.title} has been added to your wishlist',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Remove item from wishlist
  void removeFromWishlist(String productId) {
    int index = wishlistItems.indexWhere((item) => item.id == productId);
    if (index != -1) {
      String productName = wishlistItems[index].title;
      wishlistItems.removeAt(index);
      Get.snackbar(
        'Removed from Wishlist',
        '$productName has been removed from your wishlist',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Toggle wishlist status
  void toggleWishlist(HomeModel product) {
    if (isInWishlist(product.id)) {
      removeFromWishlist(product.id);
    } else {
      addToWishlist(product);
    }
  }
  
  // Clear all wishlist items
  void clearWishlist() {
    wishlistItems.clear();
    Get.snackbar(
      'Wishlist Cleared',
      'All items have been removed from your wishlist',
      duration: Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}