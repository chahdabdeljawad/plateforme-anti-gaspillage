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

  bool isLoading = false;

  static const Color primaryColor = Color(0xFF0A3B2A);
  static const Color backgroundColor = Color(0xFFF5F0E6);

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

    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<void> addProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descController.text.isEmpty ||
        selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await ApiService.addProduct(
      token!,
      nameController.text,
      priceController.text,
      descController.text,
      selectedCategory!,
    );

    setState(() {
      isLoading = false;
    });

    final bool success = result["success"] ?? false;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Product added ✅")));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"] ?? "Error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,

        iconTheme: const IconThemeData(color: primaryColor),

        title: const Text(
          "Add Product",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Container(
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(30),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: primaryColor,

                    child: Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                      size: 45,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Center(
                  child: Text(
                    "Create New Product",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplay',
                      color: primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // PRODUCT NAME
                buildTextField(
                  controller: nameController,
                  label: "Product Name",
                  icon: Icons.shopping_bag_outlined,
                ),

                const SizedBox(height: 20),

                // PRICE
                buildTextField(
                  controller: priceController,
                  label: "Price",
                  icon: Icons.attach_money_rounded,
                ),

                const SizedBox(height: 20),

                // DESCRIPTION
                buildTextField(
                  controller: descController,
                  label: "Description",
                  icon: Icons.description_outlined,
                  maxLines: 4,
                ),

                const SizedBox(height: 20),

                // CATEGORY
                DropdownButtonFormField<String>(
                  value: selectedCategory,

                  decoration: InputDecoration(
                    labelText: "Category",

                    prefixIcon: const Icon(
                      Icons.category_outlined,
                      color: primaryColor,
                    ),

                    filled: true,
                    fillColor: backgroundColor,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),

                  items: categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),

                const SizedBox(height: 25),

                // IMAGE BUTTON
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: pickImage,

                    icon: const Icon(Icons.image_outlined),

                    label: const Text("Choose Product Image"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      foregroundColor: primaryColor,

                      elevation: 0,

                      padding: const EdgeInsets.symmetric(vertical: 16),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // IMAGE PREVIEW
                if (selectedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: Image.file(
                      selectedImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 35),

                // ADD BUTTON
                SizedBox(
                  width: double.infinity,

                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : ElevatedButton(
                          onPressed: addProduct,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,

                            padding: const EdgeInsets.symmetric(vertical: 18),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),

                          child: const Text(
                            "Add Product",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(icon, color: primaryColor),

        filled: true,
        fillColor: backgroundColor,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),

          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
