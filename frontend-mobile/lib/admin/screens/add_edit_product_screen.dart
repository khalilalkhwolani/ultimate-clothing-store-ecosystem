import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myprojectshop/controller/product_controller.dart';
import 'package:myprojectshop/controller/category_controller.dart';

import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_image.dart';

class AddEditProductScreen extends StatelessWidget {
  final Product? product;

  AddEditProductScreen({super.key, this.product});

  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final selectedCategoryId = Rx<String?>(null);
  final imagePath = Rx<String?>(null);

  @override
  Widget build(BuildContext context) {
    if (product != null) {
      nameController.text = product!.name;
      descriptionController.text = product!.description ?? '';
      priceController.text = product!.price.toString();
      stockController.text = product!.stock.toString();
      selectedCategoryId.value = product!.categoryId;
      imagePath.value = product!.imageUrl;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                initialValue: product?.name,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Required';
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0)
                    return 'Invalid price';
                  return null;
                },
              ),
              TextFormField(
                controller: stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Required';
                  if (int.tryParse(value) == null || int.parse(value) < 0)
                    return 'Invalid stock';
                  return null;
                },
              ),
              Obx(() {
                return DropdownButtonFormField<String>(
                  initialValue: selectedCategoryId.value,
                  decoration: InputDecoration(labelText: 'Category'),
                  items:
                      categoryController.categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                  onChanged: (value) => selectedCategoryId.value = value,
                  validator: (value) => value == null ? 'Required' : null,
                );
              }),
              SizedBox(height: 16),
              Obx(() {
                return imagePath.value != null
                    ? CustomImage(
                      imageUrl: imagePath.value!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      borderRadius: 8,
                    )
                    : Text('No image selected');
              }),
              ElevatedButton(onPressed: _pickImage, child: Text('Pick Image')),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(product == null ? 'Add Product' : 'Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: product?.id,
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        imageUrl: imagePath.value,
        categoryId: selectedCategoryId.value,
        stock: int.parse(stockController.text),
        createdAt: product?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (product == null) {
        productController.addProduct(newProduct);
      } else {
        productController.updateProduct(newProduct);
      }

      Get.back();
    }
  }
}
