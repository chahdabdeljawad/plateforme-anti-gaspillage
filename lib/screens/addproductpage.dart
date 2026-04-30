import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final catController = TextEditingController();

  Future<void> addProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final result = await ApiService.addProduct(
      token!,
      nameController.text,
      priceController.text,
      descController.text,
      catController.text,
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
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: "Price")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "Description")),
            TextField(controller: catController, decoration: const InputDecoration(labelText: "Category")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: addProduct, child: const Text("Add"))
          ],
        ),
      ),
    );
  }
}