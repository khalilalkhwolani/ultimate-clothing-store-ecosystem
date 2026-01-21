import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myprojectshop/model/external_product_model.dart';

/// Service for fetching data from external REST APIs
class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  /// Fetch all products from external API
  static Future<List<ExternalProduct>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ExternalProduct.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  /// Fetch products by category
  static Future<List<ExternalProduct>> fetchProductsByCategory(
    String category,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/category/$category'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ExternalProduct.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  /// Fetch all categories
  static Future<List<String>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/categories'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.cast<String>();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}
