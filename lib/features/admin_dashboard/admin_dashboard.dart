import 'package:home_haven/core/util/export.dart';
import 'package:flutter/material.dart';
import 'package:home_haven/core/assets/app_colors.dart';
import 'package:home_haven/features/home/model/home_model.dart';
import 'package:get/get.dart';
import 'admin_product_controller.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminProductController controller = Get.put(AdminProductController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard Stats
            _buildDashboardStats(controller),
            SizedBox(height: 24),

            // Quick Actions
            _buildQuickActions(controller),
            SizedBox(height: 24),

            // Recent Products
            _buildRecentProducts(controller),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddProductDialog(context, controller);
        },
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Product',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildDashboardStats(AdminProductController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Products',
                        controller.totalProducts.value.toString(),
                        Icons.inventory,
                        AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Active Products',
                        controller.activeProducts.value.toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(AdminProductController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Add Product',
                    Icons.add_box,
                    AppColors.primary,
                    () => _showAddProductDialog(Get.context!, controller),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'View All',
                    Icons.list,
                    Colors.blue,
                    () => _showAllProductsDialog(Get.context!, controller),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentProducts(AdminProductController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      _showAllProductsDialog(Get.context!, controller),
                  child: Text(
                    'View All',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Obx(() {
              if (controller.products.isEmpty) {
                return Container(
                  height: 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 48, color: Colors.grey[400]),
                        SizedBox(height: 8),
                        Text(
                          'No products yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.products.length > 5
                    ? 5
                    : controller.products.length,
                itemBuilder: (context, index) {
                  final product = controller.products[index];
                  return _buildProductTile(product, controller);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTile(
      HomeModel product, AdminProductController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, color: Colors.grey[500]),
                );
              },
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title.replaceAll('"', ''),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '৳${(product.offerPrice ?? '0').replaceAll('"', '')}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.grey[600]),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                _showEditProductDialog(Get.context!, controller, product);
              } else if (value == 'delete') {
                _showDeleteConfirmation(Get.context!, controller, product);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(
      BuildContext context, AdminProductController controller) {
    controller.clearForm();
    showDialog(
      context: context,
      builder: (context) => _ProductFormDialog(
        controller: controller,
        isEdit: false,
      ),
    );
  }

  void _showEditProductDialog(BuildContext context,
      AdminProductController controller, HomeModel product) {
    controller.fillFormForEdit(product);
    showDialog(
      context: context,
      builder: (context) => _ProductFormDialog(
        controller: controller,
        isEdit: true,
        product: product,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context,
      AdminProductController controller, HomeModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text(
            'Are you sure you want to delete "${product.title.replaceAll('"', '')}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteProduct(product.id);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAllProductsDialog(
      BuildContext context, AdminProductController controller) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              Divider(),
              Expanded(
                child: Obx(() {
                  if (controller.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'No products available',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) {
                      final product = controller.products[index];
                      return _buildProductTile(product, controller);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductFormDialog extends StatelessWidget {
  final AdminProductController controller;
  final bool isEdit;
  final HomeModel? product;

  const _ProductFormDialog({
    required this.controller,
    required this.isEdit,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEdit ? 'Edit Product' : 'Add New Product',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(
                      controller: controller.titleController,
                      label: 'Product Title',
                      icon: Icons.title,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: controller.imageController,
                      label: 'Image URL',
                      icon: Icons.image,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: controller.descriptionController,
                      label: 'Description',
                      icon: Icons.description,
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    // Category Selection Dropdown
                    _buildCategoryDropdown(controller),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: controller.regularPriceController,
                            label: 'Regular Price',
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: controller.offerPriceController,
                            label: 'Offer Price',
                            icon: Icons.local_offer,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Conditional fields for Special category only
                    Obx(() => controller.selectedCategory.value == 'special'
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      controller: controller.offPriceController,
                                      label: 'Discount %',
                                      icon: Icons.percent,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _buildTextField(
                                      controller: controller.ratingController,
                                      label: 'Rating',
                                      icon: Icons.star,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: controller.ratingController,
                                  label: 'Rating',
                                  icon: Icons.star,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          )),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (isEdit) {
                              controller.updateProduct(product!.id);
                            } else {
                              controller.addProduct();
                            }
                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isEdit ? 'Update Product' : 'Add Product',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(AdminProductController controller) {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedCategory.value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
              hint: Row(
                children: [
                  Icon(Icons.category, color: AppColors.primary),
                  SizedBox(width: 12),
                  Text('Select Category'),
                ],
              ),
              items: controller.categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        color: _getCategoryColor(category),
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.selectedCategory.value = newValue;
                }
              },
            ),
          ),
        ));
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'outdoor':
        return Icons.outdoor_grill;
      case 'appliances':
        return Icons.kitchen;
      case 'furniture':
        return Icons.chair;
      case 'special':
        return Icons.local_offer;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'outdoor':
        return Color(0xFF2E7D32); // Green
      case 'appliances':
        return Color(0xFF1976D2); // Blue
      case 'furniture':
        return Color(0xFFFF9800); // Orange
      case 'special':
        return Color(0xFFD32F2F); // Red
      default:
        return Colors.grey;
    }
  }
}
