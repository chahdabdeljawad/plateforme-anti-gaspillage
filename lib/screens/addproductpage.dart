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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.onSurface),
        title: Text(
          "Add Product",
          style: TextStyle(
            color: colors.primary,
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
              color: colors.surface,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: colors.primary,
                    child: Icon(
                      Icons.shopping_bag_rounded,
                      color: colors.onPrimary,
                      size: 45,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Text(
                    "Create New Product",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplay',
                      color: colors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 35),

                // PRODUCT NAME
                buildTextField(
                  controller: nameController,
                  label: "Product Name",
                  icon: Icons.shopping_bag_outlined,
                  colors: colors,
                ),
                const SizedBox(height: 20),

                // PRICE
                buildTextField(
                  controller: priceController,
                  label: "Price",
                  icon: Icons.attach_money_rounded,
                  colors: colors,
                ),
                const SizedBox(height: 20),

                // DESCRIPTION
                buildTextField(
                  controller: descController,
                  label: "Description",
                  icon: Icons.description_outlined,
                  maxLines: 4,
                  colors: colors,
                ),
                const SizedBox(height: 20),

                // CATEGORY
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: "Category",
                    labelStyle: TextStyle(
                      color: colors.onSurface.withOpacity(0.6),
                    ),
                    prefixIcon: Icon(
                      Icons.category_outlined,
                      color: colors.primary,
                    ),
                    filled: true,
                    fillColor: colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: colors.primary, width: 2),
                    ),
                  ),
                  style: TextStyle(color: colors.onSurface),
                  items: categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(
                        cat,
                        style: TextStyle(color: colors.onSurface),
                      ),
                    );
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
                      backgroundColor: colors.surface,
                      foregroundColor: colors.primary,
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
                      ? Center(
                          child: CircularProgressIndicator(
                            color: colors.primary,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: addProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
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
    required ColorScheme colors,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: colors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: colors.primary),
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
    );
  }
}
