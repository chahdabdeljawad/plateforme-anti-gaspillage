import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import '../services/api_service.dart';
import '../lang.dart';
import '../screens/location_picker_page.dart';

class RegistrePage extends StatefulWidget {
  const RegistrePage({super.key});

  @override
  State<RegistrePage> createState() => _RegistrePageState();
}

class _RegistrePageState extends State<RegistrePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final phoneController = TextEditingController();

  String role = "client";
  bool isLoading = false;

  // Store-specific fields – stored values remain English
  final List<String> storeCategories = [
    "Restaurant",
    "Supermarket",
    "Bakery",
    "Café",
    "Butcher",
    "Fishmonger",
    "Greengrocer",
    "Other",
  ];
  String storeCategory = "Restaurant";
  String customCategory = "";
  bool isOtherCategory = false;

  LatLng? storeLocation;
  String? storePlaceName;

  Future<void> _openLocationPicker() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const LocationPickerPage()),
    );
    if (result != null && result.containsKey('lat')) {
      setState(() {
        storeLocation = LatLng(result['lat'], result['lng']);
        storePlaceName = result['name'];
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match ❌")));
      return;
    }

    // Store role validation
    if (role == "store") {
      if (storeLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select your store location")),
        );
        return;
      }
      final finalCategory = isOtherCategory ? customCategory : storeCategory;
      if (finalCategory.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a store category")),
        );
        return;
      }
    }

    setState(() => isLoading = true);

    final result = await ApiService.register(
      nameController.text.trim(),
      emailController.text.trim().toLowerCase(),
      passwordController.text,
      role,
      phone: phoneController.text.trim(),
      storeCategory: role == "store"
          ? (isOtherCategory ? customCategory : storeCategory)
          : null,
      latitude: role == "store" ? storeLocation?.latitude : null,
      longitude: role == "store" ? storeLocation?.longitude : null,
      placeName: role == "store" ? storePlaceName : null,
    );

    setState(() => isLoading = false);

    if (result["success"]) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Signup Successful ✅")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),
      appBar: AppBar(
        title: Text(
          lang.t("create_account"),
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A3B2A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    lang.t("join_us"),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplay',
                      color: Color(0xFF0A3B2A),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Full name
                  TextFormField(
                    controller: nameController,
                    decoration: _inputDecoration(lang.t("full_name")),
                    validator: (value) => value == null || value.isEmpty
                        ? lang.t("required_field")
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration(lang.t("email")),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || !value.contains("@")
                        ? lang.t("invalid_email")
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Phone (Tunisian validation)
                  TextFormField(
                    controller: phoneController,
                    decoration: _inputDecoration(lang.t("phone")),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return lang.t("required_field");
                      final regex = RegExp(
                        r'^[2579][0-9]{7}$',
                      ); // Tunisian: 8 digits starting with 2,5,7,9
                      if (!regex.hasMatch(value))
                        return "Invalid Tunisian phone number";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: _inputDecoration(lang.t("password")),
                    validator: (value) => value != null && value.length >= 4
                        ? null
                        : lang.t("weak_password"),
                  ),
                  const SizedBox(height: 16),

                  // Confirm password
                  TextFormField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: _inputDecoration(lang.t("confirm_password")),
                    validator: (value) => value == null || value.isEmpty
                        ? lang.t("required_field")
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Role dropdown – translated
                  DropdownButtonFormField<String>(
                    value: role,
                    items: [
                      DropdownMenuItem(
                        value: "client",
                        child: Text(lang.t("client")),
                      ),
                      DropdownMenuItem(
                        value: "store",
                        child: Text(lang.t("store")),
                      ),
                    ],
                    onChanged: (val) => setState(() => role = val!),
                    decoration: _inputDecoration(lang.t("role")),
                  ),

                  // Store-specific fields
                  if (role == "store") ...[
                    const SizedBox(height: 16),

                    // Store category dropdown – DISPLAY TRANSLATED, VALUE ENGLISH
                    DropdownButtonFormField<String>(
                      value: storeCategory,
                      items: storeCategories.map((cat) {
                        // Map each English category to its translation key
                        String translationKey;
                        switch (cat) {
                          case "Restaurant":
                            translationKey = "category_restaurant";
                            break;
                          case "Supermarket":
                            translationKey = "category_supermarket";
                            break;
                          case "Bakery":
                            translationKey = "category_bakery";
                            break;
                          case "Café":
                            translationKey = "category_cafe";
                            break;
                          case "Butcher":
                            translationKey = "category_butcher";
                            break;
                          case "Fishmonger":
                            translationKey = "category_fishmonger";
                            break;
                          case "Greengrocer":
                            translationKey = "category_greengrocer";
                            break;
                          case "Other":
                            translationKey = "category_other";
                            break;
                          default:
                            translationKey = cat;
                        }
                        return DropdownMenuItem<String>(
                          value: cat, // stored value stays English
                          child: Text(
                            lang.t(translationKey),
                          ), // displayed translation
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          storeCategory = val!;
                          isOtherCategory = (val == "Other");
                          if (!isOtherCategory) customCategory = "";
                        });
                      },
                      decoration: _inputDecoration(lang.t("store_category")),
                    ),
                    if (isOtherCategory) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: customCategory,
                        onChanged: (val) => customCategory = val,
                        decoration: _inputDecoration(lang.t("custom_category")),
                        validator: (value) => value == null || value.isEmpty
                            ? lang.t("required_field")
                            : null,
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Store location picker
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.t("store_location"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _openLocationPicker,
                          icon: const Icon(Icons.map),
                          label: Text(
                            storePlaceName == null
                                ? lang.t("select_location")
                                : storePlaceName!,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A3B2A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        if (storeLocation == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              lang.t("location_required"),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 30),

                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A3B2A),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(lang.t("signup")),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF0A3B2A), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
