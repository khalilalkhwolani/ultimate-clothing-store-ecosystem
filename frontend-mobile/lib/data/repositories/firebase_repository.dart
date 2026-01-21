import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myprojectshop/data/repositories/i_base_repository.dart';
import 'package:myprojectshop/model/category_modle.dart';
import 'package:myprojectshop/model/product_model.dart';

class FirebaseRepository implements IBaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Category>> fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Category.fromJson(data);
      }).toList();
    } catch (e) {
      print("Error fetching categories from Firebase: $e");
      rethrow;
    }
  }

  @override
  Future<List<Product>> fetchProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Product.fromJson(data);
      }).toList();
    } catch (e) {
      print("Error fetching products from Firebase: $e");
      rethrow;
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    await _firestore.collection('products').add(product.toMap());
  }

  @override
  Future<void> updateProduct(Product product) async {
    if (product.id == null) return;
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toMap());
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).delete();
  }

  @override
  Future<void> addCategory(Category category) async {
    await _firestore.collection('categories').add(category.toMap());
  }

  @override
  Future<void> updateCategory(Category category) async {
    if (category.id == null) return;
    await _firestore
        .collection('categories')
        .doc(category.id)
        .update(category.toMap());
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _firestore.collection('categories').doc(id).delete();
  }
}
