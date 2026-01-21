class Category {
  final String? id;
  String name;
  String? description;
  String? imageUrl;

  Category({this.id, required this.name, this.description, this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  // Universal Factory
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      name: json['name'] ?? json['category_name'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'] ?? json['image'],
    );
  }

  // Deprecated: Use fromJson instead
  factory Category.fromMap(Map<String, dynamic> map) => Category.fromJson(map);
  @override
  String toString() {
    return 'Category{id: $id, name: $name, description: $description, imageUrl: $imageUrl}';
  }
}
