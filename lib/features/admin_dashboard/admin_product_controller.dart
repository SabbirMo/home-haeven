import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/model/home_model.dart';

class AdminProductController extends GetxController {
  // Text controllers for form
  final titleController = TextEditingController();
  final imageController = TextEditingController();
  final descriptionController = TextEditingController();
  final regularPriceController = TextEditingController();
  final offerPriceController = TextEditingController();
  final offPriceController = TextEditingController();
  final ratingController = TextEditingController();

  // Category selection
  var selectedCategory = 'Outdoor'.obs;
  final categories = [
    'Outdoor',
    'Electronics',
    'Furniture',
    'Kitchen',
    'Home Decor',
    'Sports',
    'Books',
    'Fashion',
    'Other'
  ];

  // Observable variables
  var products = <HomeModel>[].obs;
  var isLoading = false.obs;
  var totalProducts = 0.obs;
  var activeProducts = 0.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  @override
  void onClose() {
    titleController.dispose();
    imageController.dispose();
    descriptionController.dispose();
    regularPriceController.dispose();
    offerPriceController.dispose();
    offPriceController.dispose();
    ratingController.dispose();
    super.onClose();
  }

  void fetchProducts() {
    _firestore
        .collection('products')
        .orderBy('id')
        .snapshots()
        .listen((snapshot) {
      products.value =
          snapshot.docs.map((doc) => HomeModel.fromJson(doc.data())).toList();
      updateStats();
    });
  }

  void updateStats() {
    totalProducts.value = products.length;
    activeProducts.value = products.where((product) => product.isActive).length;
  }

  void clearForm() {
    titleController.clear();
    imageController.clear();
    descriptionController.clear();
    regularPriceController.clear();
    offerPriceController.clear();
    offPriceController.clear();
    ratingController.text = '5.0';
    selectedCategory.value = 'Outdoor';
  }

  void fillFormForEdit(HomeModel product) {
    titleController.text = product.title.replaceAll('"', '');
    imageController.text = product.image;
    descriptionController.text = product.description;
    regularPriceController.text = product.regularPrice.replaceAll('"', '');
    offerPriceController.text = product.offerPrice.replaceAll('"', '');
    offPriceController.text = product.offPrice.replaceAll('"', '');
    ratingController.text = product.rating.replaceAll('"', '');
    selectedCategory.value = product.category;
  }

  Future<void> addProduct() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      // Generate unique ID
      String id = DateTime.now().millisecondsSinceEpoch.toString();

      final product = HomeModel(
        id: id,
        title: titleController.text.trim(),
        image: imageController.text.trim(),
        description: descriptionController.text.trim(),
        regularPrice: regularPriceController.text.trim(),
        offerPrice: offerPriceController.text.trim(),
        offPrice: offPriceController.text.trim(),
        rating: ratingController.text.trim(),
        category: selectedCategory.value,
        isActive: true,
      );

      await _firestore.collection('products').doc(id).set(product.toJson());

      Get.snackbar(
        'Success',
        'Product added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(String productId) async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      final updatedData = {
        'title': titleController.text.trim(),
        'image': imageController.text.trim(),
        'description': descriptionController.text.trim(),
        'regularPrice': regularPriceController.text.trim(),
        'offerPrice': offerPriceController.text.trim(),
        'offPrice': offPriceController.text.trim(),
        'rating': ratingController.text.trim(),
        'category': selectedCategory.value,
      };

      await _firestore
          .collection('products')
          .doc(productId)
          .update(updatedData);

      Get.snackbar(
        'Success',
        'Product updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();

      Get.snackbar(
        'Success',
        'Product deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool _validateForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter product title',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (imageController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter image URL',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (offerPriceController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter offer price',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (regularPriceController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter regular price',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
