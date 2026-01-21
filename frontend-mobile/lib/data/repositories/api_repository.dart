import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myprojectshop/core/app_config.dart';
import 'package:myprojectshop/data/repositories/i_base_repository.dart';
import 'package:myprojectshop/model/category_modle.dart';
import 'package:myprojectshop/model/product_model.dart';

class ApiRepository implements IBaseRepository {
  final String baseUrl;
  final DataSource type;

  ApiRepository({
    this.baseUrl = 'https://fakestoreapi.com',
    this.type = DataSource.FakeStore,
  });

  @override
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse(
          type == DataSource.Laravel
              ? '$baseUrl/categories'
              : '$baseUrl/products/categories',
        ),
      );

      if (response.statusCode == 200) {
        if (type == DataSource.Laravel) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => Category.fromJson(json)).toList();
        } else {
          // FakeStore Logic
          final List<dynamic> data = jsonDecode(response.body);
          final List<dynamic> duplicatedData = [...data, ...data, ...data];

          return duplicatedData.map((catName) {
            String imageUrl;
            switch (catName.toString().toLowerCase()) {
              case 'electronics':
                imageUrl =
                    'https://images.unsplash.com/photo-1498049860654-af1a5c5668ba?w=500&q=80';
                break;
              case 'jewelery':
                imageUrl =
                    'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=500&q=80';
                break;
              case "men's clothing":
                imageUrl =
                    'https://images.unsplash.com/photo-1490114538077-0a7f8cb49891?w=500&q=80';
                break;
              case "women's clothing":
                imageUrl =
                    'https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?w=500&q=80';
                break;
              default:
                imageUrl =
                    'https://via.placeholder.com/150?text=${Uri.encodeComponent(catName.toString())}';
            }

            return Category(
              id: catName.toString(),
              name: catName.toString(),
              imageUrl: imageUrl,
              description: 'Category from API',
            );
          }).toList();
        }
      } else {
        throw Exception(
          'Failed to load categories from API: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error fetching categories from API: $e");
      rethrow;
    }
  }

  @override
  Future<List<Product>> fetchProducts() async {
    try {
      final url = Uri.parse('$baseUrl/products');
      print("Fetching products from: $url"); // DEBUG LOG

      final response = await http.get(url);
      print("Response Status: ${response.statusCode}"); // DEBUG LOG

      if (response.statusCode == 200) {
        if (type == DataSource.Laravel) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          print("Laravel Response Data: ${jsonResponse['data']}"); // DEBUG LOG
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => Product.fromJson(json)).toList();
        } else {
          // FakeStore Logic
          final List<dynamic> data = jsonDecode(response.body);
          final List<dynamic> duplicatedData = [...data, ...data, ...data];
          return duplicatedData.map((json) => Product.fromJson(json)).toList();
        }
      } else {
        print("API Error Body: ${response.body}"); // DEBUG LOG
        throw Exception(
          'Failed to load products from API: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error fetching products from API: $e");
      rethrow;
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    await http.post(
      Uri.parse('$baseUrl/products'),
      body: jsonEncode(product.toMap()),
    );
  }

  @override
  Future<void> updateProduct(Product product) async {
    if (product.id == null) return;
    await http.put(
      Uri.parse('$baseUrl/products/${product.id}'),
      body: jsonEncode(product.toMap()),
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    await http.delete(Uri.parse('$baseUrl/products/$id'));
  }

  @override
  Future<void> addCategory(Category category) async {
    // Simulated
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Future<void> updateCategory(Category category) async {
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Future<void> deleteCategory(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
  }
}
