import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '../services/api_service.dart';

class AddProductPage extends StatefulWidget {

  final Map? product;

  const AddProductPage({
    super.key,
    this.product,
  });

  @override
  State<AddProductPage> createState() =>
      _AddProductPageState();
}

class _AddProductPageState
    extends State<AddProductPage> {

  final nameController =
      TextEditingController();

  final priceController =
      TextEditingController();

  final oldPriceController =
      TextEditingController();

  final descController =
      TextEditingController();

  File? selectedImage;

  Uint8List? webImage;

  String? imageName;

  bool isLoading = false;

  static const Color primaryColor =
      Color(0xFF0A3B2A);

  static const Color backgroundColor =
      Color(0xFFF5F0E6);

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

  bool get isEdit =>
      widget.product != null;

  @override
  void initState() {

    super.initState();

    // ✅ EDIT MODE
    if (isEdit) {

      final product =
          widget.product!;

      nameController.text =
          product["name"] ?? "";

      priceController.text =
          product["price"]
              .toString();

      oldPriceController.text =
          product["old_price"]
              .toString();

      descController.text =
          product["description"] ?? "";

      // ✅ FIX CATEGORY ERROR
      final category =
          product["category"]
                  ?.toString() ??
              "";

      if (categories.contains(
          category)) {

        selectedCategory =
            category;

      } else {

        selectedCategory =
            null;
      }
    }
  }

  // 📸 PICK IMAGE
  Future<void> pickImage() async {

    final picker = ImagePicker();

    final picked =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {

      imageName = picked.name;

      if (kIsWeb) {

        webImage =
            await picked.readAsBytes();

      } else {

        selectedImage =
            File(picked.path);
      }

      setState(() {});
    }
  }

  // ➕ ADD / ✏ UPDATE
  Future<void> saveProduct() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    final token =
        prefs.getString("token");

    if (token == null) return;

    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        oldPriceController
            .text.isEmpty ||
        descController.text.isEmpty ||
        selectedCategory ==
            null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
              Text("Fill all fields"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> result;

    // ✅ UPDATE
    if (isEdit) {

      result =
          await ApiService
              .updateProduct(

        token,

        widget.product!["id"],

        nameController.text,

        priceController.text,

        oldPriceController.text,

        descController.text,

        selectedCategory!,
      );

    }

    // ✅ ADD
    else {

      if ((kIsWeb &&
              webImage == null) ||
          (!kIsWeb &&
              selectedImage ==
                  null)) {

        ScaffoldMessenger.of(
                context)
            .showSnackBar(

          const SnackBar(
            content:
                Text("Choose image"),
          ),
        );

        setState(() {
          isLoading = false;
        });

        return;
      }

      result =
          await ApiService
              .addProduct(

        token,

        nameController.text,

        priceController.text,

        oldPriceController.text,

        descController.text,

        selectedCategory!,

        kIsWeb
            ? webImage!
            : selectedImage!,

        imageName!,
      );
    }

    setState(() {
      isLoading = false;
    });

    // ✅ SUCCESS
    if (result["success"] ==
        true) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(

            isEdit
                ? "Product updated ✅"
                : "Product added ✅",
          ),
        ),
      );

      // ✅ AUTO REFRESH
      Navigator.pop(
        context,
        true,
      );

    }

    // ❌ ERROR
    else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(

            result["message"] ??
                "Error",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          backgroundColor,

      appBar: AppBar(

        elevation: 0,

        centerTitle: true,

        backgroundColor:
            backgroundColor,

        iconTheme:
            const IconThemeData(
          color: primaryColor,
        ),

        title: Text(

          isEdit
              ? "Update Product"
              : "Add Product",

          style: const TextStyle(
            color: primaryColor,
            fontWeight:
                FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(
            20,
          ),

          child: Container(

            padding:
                const EdgeInsets.all(
              24,
            ),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                30,
              ),

              boxShadow: [

                BoxShadow(
                  color: Colors.black
                      .withValues(
                    alpha: 0.06,
                  ),
                  blurRadius: 10,
                  offset:
                      const Offset(
                    0,
                    4,
                  ),
                ),
              ],
            ),

            child: Column(

              children: [

                buildTextField(
                  controller:
                      nameController,
                  label:
                      "Product Name",
                  icon: Icons
                      .shopping_bag,
                ),

                const SizedBox(
                    height: 20),

                buildTextField(
                  controller:
                      priceController,
                  label: "Price",
                  icon:
                      Icons.money,
                ),

                const SizedBox(
                    height: 20),

                buildTextField(
                  controller:
                      oldPriceController,
                  label:
                      "Old Price",
                  icon: Icons
                      .local_offer,
                ),

                const SizedBox(
                    height: 20),

                buildTextField(
                  controller:
                      descController,
                  label:
                      "Description",
                  icon: Icons
                      .description,
                  maxLines: 4,
                ),

                const SizedBox(
                    height: 20),

                // ✅ CATEGORY
                DropdownButtonFormField<
                    String>(

                  value: categories
                          .contains(
                              selectedCategory)
                      ? selectedCategory
                      : null,

                  decoration:
                      InputDecoration(

                    labelText:
                        "Category",

                    filled: true,

                    fillColor:
                        backgroundColor,

                    border:
                        OutlineInputBorder(

                      borderRadius:
                          BorderRadius
                              .circular(
                        18,
                      ),

                      borderSide:
                          BorderSide
                              .none,
                    ),
                  ),

                  items: categories
                      .map((cat) {

                    return DropdownMenuItem(
                      value: cat,
                      child:
                          Text(cat),
                    );

                  }).toList(),

                  onChanged:
                      (value) {

                    setState(() {

                      selectedCategory =
                          value;
                    });
                  },
                ),

                const SizedBox(
                    height: 25),

                // 📸 IMAGE
                if (!isEdit)

                  SizedBox(

                    width:
                        double.infinity,

                    child:
                        ElevatedButton
                            .icon(

                      onPressed:
                          pickImage,

                      icon:
                          const Icon(
                        Icons.image,
                      ),

                      label:
                          const Text(
                        "Choose Image",
                      ),
                    ),
                  ),

                const SizedBox(
                    height: 20),

                // ✅ BUTTON
                SizedBox(

                  width:
                      double.infinity,

                  child: isLoading

                      ? const Center(
                          child:
                              CircularProgressIndicator(),
                        )

                      : ElevatedButton(

                          onPressed:
                              saveProduct,

                          style:
                              ElevatedButton
                                  .styleFrom(

                            backgroundColor:
                                primaryColor,

                            foregroundColor:
                                Colors.white,

                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical:
                                  18,
                            ),
                          ),

                          child: Text(

                            isEdit
                                ? "Update Product"
                                : "Add Product",

                            style:
                                const TextStyle(
                              fontSize:
                                  17,
                              fontWeight:
                                  FontWeight.bold,
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

  // 📝 TEXTFIELD
  Widget buildTextField({

    required TextEditingController
        controller,

    required String label,

    required IconData icon,

    int maxLines = 1,
  }) {

    return TextField(

      controller: controller,

      maxLines: maxLines,

      decoration: InputDecoration(

        labelText: label,

        prefixIcon: Icon(
          icon,
          color: primaryColor,
        ),

        filled: true,

        fillColor:
            backgroundColor,

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }
}