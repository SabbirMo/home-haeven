import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_haven/features/orders/model/order_model.dart';

class OrdersController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;
  var selectedStatus = OrderStatus.pending.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .get();

      orders.value = querySnapshot.docs
          .map((doc) => OrderModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch orders: $e',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus, {String? adminNotes}) async {
    try {
      isLoading.value = true;

      Map<String, dynamic> updateData = {
        'status': newStatus.toString().split('.').last,
        'adminNotes': adminNotes,
      };

      if (newStatus == OrderStatus.approved) {
        updateData['approvedDate'] = DateTime.now().toIso8601String();
      } else if (newStatus == OrderStatus.cancelled) {
        updateData['cancelledDate'] = DateTime.now().toIso8601String();
      }

      await _firestore.collection('orders').doc(orderId).update(updateData);

      // Update local orders list
      int orderIndex = orders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        OrderModel updatedOrder = orders[orderIndex].copyWith(
          status: newStatus,
          adminNotes: adminNotes,
          approvedDate: newStatus == OrderStatus.approved ? DateTime.now() : orders[orderIndex].approvedDate,
          cancelledDate: newStatus == OrderStatus.cancelled ? DateTime.now() : orders[orderIndex].cancelledDate,
        );
        orders[orderIndex] = updatedOrder;
      }

      Get.snackbar(
        'Success',
        'Order status updated to ${newStatus.displayName}',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update order status: $e',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<OrderModel> get filteredOrders {
    if (selectedStatus.value == OrderStatus.pending) {
      return orders.where((order) => order.status == OrderStatus.pending).toList();
    }
    return orders;
  }

  int get totalOrders => orders.length;
  int get pendingOrders => orders.where((order) => order.status == OrderStatus.pending).length;
  int get approvedOrders => orders.where((order) => order.status == OrderStatus.approved).length;
  int get cancelledOrders => orders.where((order) => order.status == OrderStatus.cancelled).length;

  double get totalRevenue => orders
      .where((order) => order.status != OrderStatus.cancelled)
      .fold(0.0, (sum, order) => sum + order.totalAmount);

  void filterByStatus(OrderStatus status) {
    selectedStatus.value = status;
  }

  void showOrderActionDialog(OrderModel order) {
    Get.dialog(
      AlertDialog(
        title: Text('Manage Order #${order.id.substring(0, 8)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${order.customerName}'),
            Text('Total: ৳${order.totalAmount.toStringAsFixed(0)}'),
            Text('Status: ${order.status.displayName}'),
            SizedBox(height: 16),
            Text('Choose Action:', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          if (order.status == OrderStatus.pending) ...[
            TextButton(
              onPressed: () {
                Get.back();
                _showApproveDialog(order);
              },
              child: Text('Approve', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                _showCancelDialog(order);
              },
              child: Text('Cancel Order', style: TextStyle(color: Colors.red)),
            ),
          ],
          if (order.status == OrderStatus.approved) ...[
            TextButton(
              onPressed: () {
                Get.back();
                updateOrderStatus(order.id, OrderStatus.processing);
              },
              child: Text('Mark as Processing', style: TextStyle(color: Colors.blue)),
            ),
          ],
          if (order.status == OrderStatus.processing) ...[
            TextButton(
              onPressed: () {
                Get.back();
                updateOrderStatus(order.id, OrderStatus.shipped);
              },
              child: Text('Mark as Shipped', style: TextStyle(color: Colors.purple)),
            ),
          ],
          if (order.status == OrderStatus.shipped) ...[
            TextButton(
              onPressed: () {
                Get.back();
                updateOrderStatus(order.id, OrderStatus.delivered);
              },
              child: Text('Mark as Delivered', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ],
      ),
    );
  }

  void _showApproveDialog(OrderModel order) {
    final TextEditingController notesController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: Text('Approve Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to approve this order?'),
            SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'Admin Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              updateOrderStatus(
                order.id, 
                OrderStatus.approved, 
                adminNotes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Approve Order'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(OrderModel order) {
    final TextEditingController reasonController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: Text('Cancel Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to cancel this order?'),
            SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: 'Cancellation Reason (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              updateOrderStatus(
                order.id, 
                OrderStatus.cancelled, 
                adminNotes: reasonController.text.trim().isEmpty ? null : reasonController.text.trim(),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Cancel Order'),
          ),
        ],
      ),
    );
  }
}