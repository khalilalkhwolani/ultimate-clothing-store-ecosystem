import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/model/category_modle.dart';

abstract class IBaseRepository {
  Future<List<Product>> fetchProducts();
  Future<List<Category>> fetchCategories();

  // Write operations (Optional for API if read-only)
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);

  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
}
