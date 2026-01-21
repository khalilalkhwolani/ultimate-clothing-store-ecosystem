import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/category_controller.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/product_controller.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/screens/product_details_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';
import 'package:myprojectshop/widgets/custom_image.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({Key? key}) : super(key: key);

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final AuthController authController = Get.find<AuthController>();
  final CartController cartController = Get.find<CartController>();

  final TextEditingController searchController = TextEditingController();
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategoryId = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 1000.0.obs;
  final RxString sortBy = 'name'.obs;

  @override
  void initState() {
    super.initState();
    filteredProducts.value = productController.products;
  }

  void _filterProducts() {
    List<Product> result = productController.products.toList();

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      result =
          result
              .where(
                (p) =>
                    p.name.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ||
                    (p.description?.toLowerCase().contains(
                          searchQuery.value.toLowerCase(),
                        ) ??
                        false),
              )
              .toList();
    }

    // Category filter
    if (selectedCategoryId.value.isNotEmpty) {
      result =
          result
              .where((p) => p.categoryId == selectedCategoryId.value)
              .toList();
    }

    // Price filter
    result =
        result
            .where(
              (p) => p.price >= minPrice.value && p.price <= maxPrice.value,
            )
            .toList();

    // Sorting
    switch (sortBy.value) {
      case 'name':
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'price_low':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'newest':
        result.sort((a, b) => (b.id ?? '').compareTo(a.id ?? ''));
        break;
    }

    filteredProducts.value = result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverCustomAppBar(
            title: context.l10n.searchFilter,
            showBackButton: true,
            actions: [
              IconButton(
                icon: Icon(Icons.tune),
                onPressed: () => _showFilterBottomSheet(context),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Search Bar
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      searchQuery.value = value;
                      _filterProducts();
                    },
                    decoration: InputDecoration(
                      hintText: context.l10n.searchProducts,
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppTheme.primaryColor,
                      ),
                      suffixIcon: Obx(
                        () =>
                            searchQuery.value.isNotEmpty
                                ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    searchQuery.value = '';
                                    _filterProducts();
                                  },
                                )
                                : SizedBox.shrink(),
                      ),
                      filled: true,
                      fillColor: AppTheme.backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                ),

                // Category Chips
                Container(
                  height: 50,
                  color: Colors.white,
                  child: Obx(
                    () => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      itemCount: categoryController.categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(context.l10n.all),
                              selected: selectedCategoryId.value.isEmpty,
                              selectedColor: AppTheme.primaryColor,
                              labelStyle: TextStyle(
                                color:
                                    selectedCategoryId.value.isEmpty
                                        ? Colors.white
                                        : Colors.grey[700],
                              ),
                              onSelected: (selected) {
                                selectedCategoryId.value = '';
                                _filterProducts();
                              },
                            ),
                          );
                        }
                        final category =
                            categoryController.categories[index - 1];
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(category.name),
                            selected: selectedCategoryId.value == category.id,
                            selectedColor: AppTheme.primaryColor,
                            labelStyle: TextStyle(
                              color:
                                  selectedCategoryId.value == category.id
                                      ? Colors.white
                                      : Colors.grey[700],
                            ),
                            onSelected: (selected) {
                              selectedCategoryId.value =
                                  selected ? (category.id ?? '') : '';
                              _filterProducts();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Results Count & Sort
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          '${filteredProducts.length} ${context.l10n.productsFound}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showSortBottomSheet(context),
                        child: Row(
                          children: [
                            Icon(
                              Icons.sort,
                              size: 18,
                              color: AppTheme.primaryColor,
                            ),
                            SizedBox(width: 4),
                            Obx(
                              () => Text(
                                _getSortLabel(),
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if (filteredProducts.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                      SizedBox(height: 16),
                      Text(
                        context.l10n.noResults,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        context.l10n.adjustFilters,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildProductCard(filteredProducts[index]);
                }, childCount: filteredProducts.length),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailsScreen(product: product)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: CustomImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          cartController.addToCart(product);
                          AppSnackbar.showSuccess(
                            '${product.name} ${context.l10n.itemAddedToCartNamed}',
                            title: context.l10n.added,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSortLabel() {
    switch (sortBy.value) {
      case 'name':
        return context.l10n.name;
      case 'price_low':
        return context.l10n.priceLowHigh;
      case 'price_high':
        return context.l10n.priceHighLow;
      case 'newest':
        return context.l10n.newest;
      default:
        return context.l10n.sort;
    }
  }

  void _showSortBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.sortBy,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildSortOption(context.l10n.nameAZ, 'name'),
            _buildSortOption(context.l10n.priceLowHighLabel, 'price_low'),
            _buildSortOption(context.l10n.priceHighLowLabel, 'price_high'),
            _buildSortOption(context.l10n.newestFirst, 'newest'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    return Obx(
      () => ListTile(
        title: Text(label),
        trailing:
            sortBy.value == value
                ? Icon(Icons.check, color: AppTheme.primaryColor)
                : null,
        onTap: () {
          sortBy.value = value;
          _filterProducts();
          Get.back();
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.filters,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    selectedCategoryId.value = '';
                    minPrice.value = 0;
                    maxPrice.value = 1000;
                    _filterProducts();
                  },
                  child: Text(context.l10n.reset),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              context.l10n.priceRange,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Obx(
              () => RangeSlider(
                values: RangeValues(minPrice.value, maxPrice.value),
                min: 0,
                max: 1000,
                divisions: 100,
                activeColor: AppTheme.primaryColor,
                labels: RangeLabels(
                  '\$${minPrice.value.toInt()}',
                  '\$${maxPrice.value.toInt()}',
                ),
                onChanged: (values) {
                  minPrice.value = values.start;
                  maxPrice.value = values.end;
                },
                onChangeEnd: (values) => _filterProducts(),
              ),
            ),
            Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${minPrice.value.toInt()}'),
                    Text('\$${maxPrice.value.toInt()}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  context.l10n.applyFilters,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
