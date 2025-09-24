import 'package:get/get.dart';
import 'package:home_haven/features/cart/model/cart_model.dart';
import 'package:home_haven/features/home/model/home_model.dart';

class CartController extends GetxController {
  var cartItems = <CartModel>[].obs;
  
  // Calculate total price
  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
  
  // Calculate total savings
  double get totalSavings {
    return cartItems.fold(0.0, (sum, item) => sum + ((item.originalPrice - item.price) * item.quantity));
  }
  
  // Get total items count
  int get itemCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Add item to cart
  void addToCart(HomeModel product, String selectedColor) {
    // Check if item already exists in cart
    int existingIndex = cartItems.indexWhere((item) => 
        item.id == product.id && item.color == selectedColor);
    
    if (existingIndex != -1) {
      // Item exists, increase quantity
      cartItems[existingIndex].quantity++;
      cartItems.refresh();
    } else {
      // Add new item
      CartModel newItem = CartModel(
        id: product.id,
        name: product.title,
        image: product.image,
        price: double.tryParse(product.offerPrice.replaceAll('\$', '')) ?? 0.0,
        originalPrice: double.tryParse(product.regularPrice.replaceAll('\$', '')) ?? 0.0,
        discountPercentage: product.offPrice,
        color: selectedColor,
      );
      cartItems.add(newItem);
    }
    
    Get.snackbar(
      'Added to Cart',
      '${product.title} has been added to your cart',
      duration: Duration(seconds: 2),
    );
  }

  // Remove item from cart
  void removeFromCart(String itemId, String color) {
    cartItems.removeWhere((item) => item.id == itemId && item.color == color);
  }

  // Update quantity
  void updateQuantity(String itemId, String color, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(itemId, color);
      return;
    }
    
    int index = cartItems.indexWhere((item) => item.id == itemId && item.color == color);
    if (index != -1) {
      cartItems[index].quantity = newQuantity;
      cartItems.refresh();
    }
  }

  // Increase quantity
  void increaseQuantity(String itemId, String color) {
    int index = cartItems.indexWhere((item) => item.id == itemId && item.color == color);
    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    }
  }

  // Decrease quantity
  void decreaseQuantity(String itemId, String color) {
    int index = cartItems.indexWhere((item) => item.id == itemId && item.color == color);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
      } else {
        removeFromCart(itemId, color);
      }
    }
  }

  // Clear cart
  void clearCart() {
    cartItems.clear();
  }
}