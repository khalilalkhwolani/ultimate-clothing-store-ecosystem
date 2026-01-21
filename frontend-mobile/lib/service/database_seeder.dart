import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myprojectshop/model/category_modle.dart';
import 'package:myprojectshop/model/product_model.dart';

import 'package:myprojectshop/utils/app_snackbar.dart';

class DatabaseSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> seedDatabase() async {
    try {
      print('Starting Database Cleanup...');
      await clearDatabase();
      print('Database Cleanup Completed.');

      await seedCategories();
      await seedProducts();

      return true;
    } catch (e) {
      print('Seeding Error: $e');
      AppSnackbar.showError('Error: ${e.toString()}', title: 'Seeding Failed');
      return false;
    }
  }

  Future<void> clearDatabase() async {
    try {
      // Clear Categories
      print('Fetching categories for deletion...');
      final categories = await _firestore.collection('categories').get();
      print('Found ${categories.docs.length} categories to delete.');

      if (categories.docs.isNotEmpty) {
        WriteBatch batch = _firestore.batch();
        for (var doc in categories.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        print('All categories deleted.');
      }

      // Clear Products
      print('Fetching products for deletion...');
      final products = await _firestore.collection('products').get();
      print('Found ${products.docs.length} products to delete.');

      if (products.docs.isNotEmpty) {
        WriteBatch batch = _firestore.batch();
        for (var doc in products.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        print('All products deleted.');
      }
    } catch (e) {
      print('Error during database cleanup: $e');
      rethrow;
    }
  }

  Future<void> seedCategories() async {
    final categoriesCollection = _firestore.collection('categories');

    print('Starting Category Seeding...');
    List<Category> categories = [
      Category(id: 'men', name: 'Men', description: 'Men\'s Clothing'),
      Category(id: 'women', name: 'Women', description: 'Women\'s Clothing'),
      Category(id: 'kids', name: 'Kids', description: 'Kids\' Clothing'),
      Category(
        id: 'accessories',
        name: 'Accessories',
        description: 'Fashion Accessories',
      ),
    ];

    for (var category in categories) {
      try {
        await categoriesCollection.doc(category.id).set(category.toMap());
        print('Successfully seeded category: ${category.name}');
      } catch (e) {
        print('Error seeding category ${category.name}: $e');
      }
    }
    print('Category seeding completed.');
  }

  Future<void> seedProducts() async {
    final productsCollection = _firestore.collection('products');

    print('Starting Product Seeding...');
    List<Product> products = [
      Product(
        id: 'p1',
        name: 'Classic T-Shirt',
        description: 'A comfortable cotton t-shirt.',
        price: 29.99,
        imageUrl:
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=600&auto=format&fit=crop',
        categoryId: 'men',
        stock: 100,
        createdAt: DateTime.now(),
      ),
      Product(
        id: 'p2',
        name: 'Slim Fit Jeans',
        description: 'Stylish slim fit jeans.',
        price: 49.99,
        imageUrl:
            'https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=600&auto=format&fit=crop',
        categoryId: 'men',
        stock: 50,
        createdAt: DateTime.now(),
      ),
      Product(
        id: 'p3',
        name: 'Summer Dress',
        description: 'Light and breezy summer dress.',
        price: 39.99,
        imageUrl:
            'https://images.unsplash.com/photo-1496747611176-843222e1e57c?q=80&w=600&auto=format&fit=crop',
        categoryId: 'women',
        stock: 30,
        createdAt: DateTime.now(),
      ),
      Product(
        id: 'p4',
        name: 'Leather Jacket',
        description: 'Premium leather jacket.',
        price: 129.99,
        imageUrl:
            'https://images.unsplash.com/photo-1551028719-00167b16eac5?q=80&w=600&auto=format&fit=crop',
        categoryId: 'women',
        stock: 20,
        createdAt: DateTime.now(),
      ),
      Product(
        id: 'p5',
        name: 'Kids Hoodie',
        description: 'Warm hoodie for kids.',
        price: 24.99,
        imageUrl:
            'https://images.unsplash.com/photo-1556905055-8f358a7a4bb4?q=80&w=600&auto=format&fit=crop',
        categoryId: 'kids',
        stock: 60,
        createdAt: DateTime.now(),
      ),
      Product(
        id: 'p6',
        name: 'Sunglasses',
        description: 'UV protection sunglasses.',
        price: 19.99,
        imageUrl:
            'https://images.unsplash.com/photo-1572635196237-14b3f281503f?q=80&w=600&auto=format&fit=crop',
        categoryId: 'accessories',
        stock: 150,
        createdAt: DateTime.now(),
      ),
    ];

    for (var product in products) {
      try {
        await productsCollection.doc(product.id).set(product.toMap());
        print('Successfully seeded product: ${product.name}');
      } catch (e) {
        print('Error seeding product ${product.name}: $e');
      }
    }
    print('Product seeding completed.');
  }
}
