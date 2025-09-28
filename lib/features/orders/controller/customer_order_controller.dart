// controller/customer_order_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/order_model.dart';

class CustomerOrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var customerOrders = <OrderModel>[].obs;
  var isLoading = false.obs;
  var selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomerOrders();
  }

  Future<void> fetchCustomerOrders() async {
    try {
      isLoading.value = true;
      print('\n=== 🚀 STARTING ORDER FETCH ===');

      final user = _auth.currentUser;
      if (user == null) {
        print('❌ NO USER AUTHENTICATED');
        Get.snackbar('Authentication Error', 'Please log in first',
            backgroundColor: Colors.red[100], colorText: Colors.red[800]);
        return;
      }

      print('✅ User authenticated: ${user.uid}');
      print('📧 User email: ${user.email}');
      print('🔍 Querying Firestore collection: "orders"');
      print('📝 Query filter: userId == ${user.uid}');

      try {
        QuerySnapshot snapshot = await _firestore
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .orderBy('orderDate', descending: true)
            .get();

        print('📊 Found ${snapshot.docs.length} documents');

        if (snapshot.docs.isEmpty) {
          print('⚠️ No orders found for user: ${user.uid}');
          print('💡 Possible reasons:');
          print('   1. User has not placed any orders yet');
          print('   2. Orders collection is empty');
          print('   3. userId field mismatch in existing orders');
          customerOrders.clear();
        } else {
          print('📄 Processing documents...');
          List<OrderModel> orders = [];

          for (var doc in snapshot.docs) {
            try {
              print('📋 Processing document ID: ${doc.id}');
              var data = doc.data() as Map<String, dynamic>;
              print('🔑 Document data keys: ${data.keys.toList()}');

              var order = OrderModel.fromJson({
                'id': doc.id,
                ...data,
              });

              orders.add(order);
              print('✅ Order ${doc.id.substring(0, 8)} parsed successfully');
            } catch (e) {
              print('❌ Error parsing order ${doc.id}: $e');
            }
          }

          customerOrders.value = orders;
          print('🎉 Successfully loaded ${customerOrders.length} orders');
          print(
              '📋 Order IDs: ${customerOrders.map((o) => o.id.substring(0, 8)).toList()}');
        }
      } catch (firestoreError) {
        print('❌ Firestore query error: $firestoreError');

        if (firestoreError.toString().contains('index')) {
          print('🔧 Missing index error - trying fallback query...');
          try {
            QuerySnapshot snapshot = await _firestore
                .collection('orders')
                .where('userId', isEqualTo: user.uid)
                .get();

            print('📊 Fallback query found ${snapshot.docs.length} documents');

            customerOrders.value = snapshot.docs
                .map((doc) => OrderModel.fromJson({
                      'id': doc.id,
                      ...doc.data() as Map<String, dynamic>,
                    }))
                .toList();

            // Sort locally
            customerOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
            print(
                '✅ Fallback query successful: ${customerOrders.length} orders loaded');
          } catch (fallbackError) {
            print('❌ Fallback query also failed: $fallbackError');
            throw fallbackError;
          }
        } else {
          throw firestoreError;
        }
      }
    } catch (e) {
      print('❌ General error in fetchCustomerOrders: $e');
      Get.snackbar('Error', 'Failed to fetch orders: ${e.toString()}',
          backgroundColor: Colors.red[100], colorText: Colors.red[800]);
    } finally {
      isLoading.value = false;
      print('=== ORDER FETCH COMPLETED ===\n');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      isLoading.value = true;
      await _firestore.collection('orders').doc(orderId).update({
        'status': 'cancelled',
        'cancelledDate': DateTime.now().toIso8601String(),
        'adminNotes': 'Cancelled by customer',
      });

      final index = customerOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        customerOrders[index] = customerOrders[index].copyWith(
          status: OrderStatus.cancelled,
          cancelledDate: DateTime.now(),
          adminNotes: 'Cancelled by customer',
        );
      }

      Get.snackbar('Success', 'Order cancelled',
          backgroundColor: Colors.orange[100], colorText: Colors.orange[800]);
    } catch (e) {
      print('Cancel order error: $e');
      Get.snackbar('Error', 'Failed to cancel order',
          backgroundColor: Colors.red[100], colorText: Colors.red[800]);
    } finally {
      isLoading.value = false;
    }
  }

  List<OrderModel> get filteredOrders {
    switch (selectedFilter.value) {
      case 'pending':
        return customerOrders
            .where((o) => o.status == OrderStatus.pending)
            .toList();
      case 'processing':
        return customerOrders
            .where((o) =>
                o.status == OrderStatus.processing ||
                o.status == OrderStatus.approved ||
                o.status == OrderStatus.shipped)
            .toList();
      case 'delivered':
        return customerOrders
            .where((o) => o.status == OrderStatus.delivered)
            .toList();
      case 'cancelled':
        return customerOrders
            .where((o) => o.status == OrderStatus.cancelled)
            .toList();
      default:
        return customerOrders;
    }
  }

  void filterByStatus(String status) => selectedFilter.value = status;

  int get totalOrders => customerOrders.length;
  int get pendingOrders =>
      customerOrders.where((o) => o.status == OrderStatus.pending).length;
  int get processingOrders => customerOrders
      .where((o) =>
          o.status == OrderStatus.processing ||
          o.status == OrderStatus.approved ||
          o.status == OrderStatus.shipped)
      .length;
  int get deliveredOrders =>
      customerOrders.where((o) => o.status == OrderStatus.delivered).length;
  int get cancelledOrders =>
      customerOrders.where((o) => o.status == OrderStatus.cancelled).length;

  double get totalSpent => customerOrders
      .where((o) => o.status != OrderStatus.cancelled)
      .fold(0, (sum, o) => sum + o.totalAmount);

  // Debug method to check Firebase collection
  Future<void> debugFirebaseOrders() async {
    try {
      print('\n=== 🔍 FIREBASE DEBUG CHECK ===');

      // Check total orders in collection
      QuerySnapshot allOrders = await _firestore.collection('orders').get();
      print('📊 Total orders in Firebase: ${allOrders.docs.length}');

      if (allOrders.docs.isNotEmpty) {
        print('📄 Sample order data:');
        for (var doc in allOrders.docs.take(3)) {
          var data = doc.data() as Map<String, dynamic>;
          print('   ID: ${doc.id}');
          print('   UserId: ${data['userId'] ?? 'NOT SET'}');
          print('   Status: ${data['status'] ?? 'NOT SET'}');
          print('   Date: ${data['orderDate'] ?? 'NOT SET'}');
          print('   ---');
        }
      }

      // Check current user
      final user = _auth.currentUser;
      if (user != null) {
        print('👤 Current user: ${user.uid}');

        // Check orders for current user
        QuerySnapshot userOrders = await _firestore
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .get();
        print('📋 Orders for current user: ${userOrders.docs.length}');
      }

      print('=== DEBUG CHECK COMPLETED ===\n');
    } catch (e) {
      print('❌ Debug check failed: $e');
    }
  }
}
