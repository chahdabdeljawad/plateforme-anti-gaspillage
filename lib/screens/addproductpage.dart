import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/api_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();

  File? selectedImage;

  // نفس categories الموجودة في CategoriesPage
  final List<String> categories = [
    "Carrefour",
    "MG",
    "Monoprix",
    "Aziza",
    "Restaurants",
    "Boulangeries",
    "Pâtisseries",
    "Poissonneries",
    "Fromageries",
    "Primeurs",
    "Petits commerces",
  ];

  String? selectedCategory;

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<void> addProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Choose a category")),
      );
      return;
    }

    final result = await ApiService.addProduct(
      token!,
      nameController.text,
      priceController.text,
      descController.text,
      selectedCategory!,
      // بعدين نزيد image في backend
    );

    if (result["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added ✅")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"] ?? "Error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Product name",
              ),
            ),

            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: "Price",
              ),
            ),

            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Category",
              ),
              items: categories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Choose product image"),
            ),

            const SizedBox(height: 10),

            if (selectedImage != null)
              Image.file(
                selectedImage!,
                height: 150,
              ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: addProduct,
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}