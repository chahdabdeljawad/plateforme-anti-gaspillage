import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import '../lang.dart';
import '../screens/location_picker_page.dart';


class RegistrePage extends StatefulWidget {
  final VoidCallback onBack;

  const RegistrePage({super.key, required this.onBack});

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

  // Localisation (store + livreur)
  LatLng? storeLocation;
  String? storePlaceName;

  // Livreur-specific fields
  final List<String> vehicles = ["Moto", "Voiture", "Vélo"];
  String vehicle = "Moto";

  Future<void> _openLocationPicker() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerPage(
          onConfirm: (result) {
            Navigator.pop(context, result);
          },
          onCancel: () {
            Navigator.pop(context);
          },
        ),
      ),
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

    // 🚚 Livreur location validation
    if (role == "livreur") {
      if (storeLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select your location")),
        );
        return;
      }
    }

    setState(() => isLoading = true);

    // Register unifié (client / store / livreur)
    final result = await ApiService.register(
      nameController.text.trim(),
      emailController.text.trim().toLowerCase(),
      passwordController.text,
      role,
      phone: phoneController.text.trim(),
      storeCategory: role == "store"
          ? (isOtherCategory ? customCategory : storeCategory)
          : null,
      latitude: (role == "store" || role == "livreur")
          ? storeLocation?.latitude
          : null,
      longitude: (role == "store" || role == "livreur")
          ? storeLocation?.longitude
          : null,
      placeName: role == "store" ? storePlaceName : null,
      vehicle: role == "livreur" ? vehicle : null,
    );

    setState(() => isLoading = false);

    if (result["success"]) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Signup Successful ✅")));
      widget.onBack();
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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onPrimary),
          onPressed: widget.onBack,
        ),
        title: Text(
          lang.t("create_account"),
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            color: colors.onPrimary,
          ),
        ),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    lang.t("join_us"),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplay',
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Full name
                  TextFormField(
                    controller: nameController,
                    decoration: _inputDecoration(lang.t("full_name"), colors),
                    style: TextStyle(color: colors.onSurface),
                    validator: (value) => value == null || value.isEmpty
                        ? lang.t("required_field")
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration(lang.t("email"), colors),
                    style: TextStyle(color: colors.onSurface),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || !value.contains("@")
                        ? lang.t("invalid_email")
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Phone (Tunisian validation)
                  TextFormField(
                    controller: phoneController,
                    decoration: _inputDecoration(lang.t("phone"), colors),
                    style: TextStyle(color: colors.onSurface),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return lang.t("required_field");
                      final regex = RegExp(r'^[2579][0-9]{7}$');
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
                    decoration: _inputDecoration(lang.t("password"), colors),
                    style: TextStyle(color: colors.onSurface),
                    validator: (value) => value != null && value.length >= 4
                        ? null
                        : lang.t("weak_password"),
                  ),
                  const SizedBox(height: 16),

                  // Confirm password
                  TextFormField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: _inputDecoration(
                      lang.t("confirm_password"),
                      colors,
                    ),
                    style: TextStyle(color: colors.onSurface),
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
                        child: Text(
                          lang.t("client"),
                          style: TextStyle(color: colors.onSurface),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "store",
                        child: Text(
                          lang.t("store"),
                          style: TextStyle(color: colors.onSurface),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "livreur",
                        child: Text(
                          "Livreur",
                          style: TextStyle(color: colors.onSurface),
                        ),
                      ),
                    ],
                    onChanged: (val) => setState(() => role = val!),
                    decoration: _inputDecoration(lang.t("role"), colors),
                    style: TextStyle(color: colors.onSurface),
                  ),

                  // 🚚 Livreur-specific fields
                  if (role == "livreur") ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: vehicle,
                      items: vehicles
                          .map(
                            (v) => DropdownMenuItem(
                              value: v,
                              child: Text(
                                v,
                                style: TextStyle(color: colors.onSurface),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => vehicle = val!),
                      decoration: _inputDecoration("Véhicule", colors),
                      style: TextStyle(color: colors.onSurface),
                    ),

                    // 🆕 Localisation livreur
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Localisation",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
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
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
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

                  // Store-specific fields
                  if (role == "store") ...[
                    const SizedBox(height: 16),

                    // Store category dropdown
                    DropdownButtonFormField<String>(
                      value: storeCategory,
                      items: storeCategories.map((cat) {
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
                          value: cat,
                          child: Text(
                            lang.t(translationKey),
                            style: TextStyle(color: colors.onSurface),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          storeCategory = val!;
                          isOtherCategory = (val == "Other");
                          if (!isOtherCategory) customCategory = "";
                        });
                      },
                      decoration: _inputDecoration(
                        lang.t("store_category"),
                        colors,
                      ),
                      style: TextStyle(color: colors.onSurface),
                    ),
                    if (isOtherCategory) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: customCategory,
                        onChanged: (val) => customCategory = val,
                        decoration: _inputDecoration(
                          lang.t("custom_category"),
                          colors,
                        ),
                        style: TextStyle(color: colors.onSurface),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
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
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
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
                      ? CircularProgressIndicator(color: colors.primary)
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(lang.t("signup")),
                        ),


                  const SizedBox(height: 40),

                ],
                
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, ColorScheme colors) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.6)),
      filled: true,
      fillColor: colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}