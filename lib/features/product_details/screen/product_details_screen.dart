import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_haven/core/assets/app_colors.dart';
import 'package:home_haven/features/home/model/home_model.dart';
import 'package:home_haven/features/onboarding/widget/custom_button.dart';
import 'package:home_haven/features/cart/controller/cart_controller.dart';
import 'package:home_haven/features/cart/my_cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final HomeModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selectedColorIndex = 0;
  late CartController cartController;

  @override
  void initState() {
    super.initState();
    cartController = Get.put(CartController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image Section
                  Container(
                    height: 400,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              _getSelectedColor().withOpacity(0.3),
                              BlendMode.multiply,
                            ),
                            child: Image.network(
                              widget.product.image,
                              width: double.infinity,
                              height: 400,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 400,
                                  decoration: BoxDecoration(
                                    color: _getSelectedColor().withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chair,
                                        color: _getSelectedColor(),
                                        size: 100,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Sofa Preview',
                                        style: TextStyle(
                                          color: _getSelectedColor(),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Product Info Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Title
                        Text(
                          widget.product.title.toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Price Section
                        Row(
                          children: [
                            Text(
                              widget.product.offerPrice,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 12),
                            if (widget.product.regularPrice !=
                                widget.product.offerPrice)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  widget.product.offPrice,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        if (widget.product.regularPrice !=
                            widget.product.offerPrice)
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              widget.product.regularPrice,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),

                        SizedBox(height: 16),

                        // Rating Section
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4),
                            Text(
                              widget.product.rating,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              ' (256)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24),

                        // Description
                        Text(
                          widget.product.description.isNotEmpty
                              ? widget.product.description
                              : 'A minimalist chair with a reversible back cushion provides soft support for your back and has two sides to wear.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: 32),

                        // Colors Section
                        Text(
                          'Colors',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),

                        SizedBox(height: 16),

                        // Color Options
                        _buildColorOptions(),

                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Wishlist Button
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.black87,
                        size: 24,
                      ),
                      onPressed: () {
                        Get.snackbar(
                          'Added to Wishlist',
                          '${widget.product.title} added to your wishlist',
                          backgroundColor: Colors.grey[800],
                          colorText: Colors.white,
                          duration: Duration(seconds: 2),
                        );
                      },
                    ),
                  ),

                  SizedBox(width: 16),

                  // Add to Cart Button
                  Expanded(
                    child: CustomButton(
                      text: 'Add to Cart',
                      onTap: () {
                        final selectedColor = _getSelectedColorName();
                        cartController.addToCart(widget.product, selectedColor);

                        // Navigate to cart page
                        Get.to(() => MyCartScreen());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOptions() {
    final colors = [
      {'name': 'Harvest Gold', 'color': Color(0xFFE6A623)},
      {'name': 'Eerie Black', 'color': Color(0xFF1C1C1C)},
      {'name': 'Flame', 'color': Color(0xFFE55722)},
      {'name': 'Pakistan Green', 'color': Color(0xFF2E7D32)},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> colorOption = entry.value;
        bool isSelected = selectedColorIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedColorIndex = index;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Color(0xFF2E7D32) : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colorOption['color'] as Color,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 0.5,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  colorOption['name'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Color(0xFF2E7D32) : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getSelectedColor() {
    final colors = [
      Color(0xFFE6A623), // Harvest Gold
      Color(0xFF1C1C1C), // Eerie Black
      Color(0xFFE55722), // Flame
      Color(0xFF2E7D32), // Pakistan Green
    ];
    return colors[selectedColorIndex];
  }

  String _getSelectedColorName() {
    final colorNames = [
      'Harvest Gold',
      'Eerie Black',
      'Flame',
      'Pakistan Green',
    ];
    return colorNames[selectedColorIndex];
  }
}
