import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myprojectshop/model/external_product_model.dart';
import 'package:myprojectshop/service/api_service.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/screens/product_details_screen.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/theme/theme.dart';

/// Screen to display products fetched from external API
/// This screen satisfies the academic requirement: "Use an API to display some of the application's data stored on an external server"
class ExternalProductsScreen extends StatefulWidget {
  const ExternalProductsScreen({Key? key}) : super(key: key);

  @override
  State<ExternalProductsScreen> createState() => _ExternalProductsScreenState();
}

class _ExternalProductsScreenState extends State<ExternalProductsScreen> {
  late Future<List<ExternalProduct>> _productsFuture;
  String _selectedCategory = 'all';
  List<String> _categories = ['all'];

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService.fetchProducts();
    _loadCategories();
  }

  void _loadCategories() async {
    try {
      final categories = await ApiService.fetchCategories();
      setState(() {
        _categories = ['all', ...categories];
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'all') {
        _productsFuture = ApiService.fetchProducts();
      } else {
        _productsFuture = ApiService.fetchProductsByCategory(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Online Store'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppTheme.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category Filter Chips
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryColor,
                    backgroundColor: Colors.white,
                    onSelected: (_) => _filterByCategory(category),
                  ),
                );
              },
            ),
          ),
          // Products Grid
          Expanded(
            child: FutureBuilder<List<ExternalProduct>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: AppTheme.error,
                        ),
                        SizedBox(height: 16),
                        Text('Error loading products'),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _productsFuture = ApiService.fetchProducts();
                            });
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products found'));
                }

                final products = snapshot.data!;
                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildProductCard(product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ExternalProduct product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Convert ExternalProduct to Product model for details screen
          final internalProduct = Product(
            id: product.id.toString(),
            name: product.title,
            description: product.description,
            price: product.price,
            imageUrl: product.image,
            categoryId: null, // No direct mapping for external categories
            stock: 100, // Default stock for external products
          );

          Get.to(() => ProductDetailsScreen(product: internalProduct));
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.contain,
                    placeholder:
                        (context, url) => Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        Text(
                          ' ${product.rating.rate}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          ' (${product.rating.count})',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
