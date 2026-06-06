import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/footer.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import '../lang.dart';
import 'mappage.dart';
import 'paymentpage.dart';
import 'panierpage.dart';

class ReservationPage extends StatefulWidget {
  final int productId;
  final int clientId;
  final String productName;
  final String price;
  final String oldPrice;
  final String description;
  final String image;
  final double lat;
  final double lng;
  final String storeName;
  final String time;
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onConfirm;

  const ReservationPage({
    super.key,
    required this.productId,
    required this.clientId,
    required this.productName,
    required this.price,
    required this.oldPrice,
    required this.description,
    required this.image,
    required this.lat,
    required this.lng,
    required this.storeName,
    required this.time,
    required this.onBack,
    required this.onConfirm,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  String deliveryType = "sur_place";
  late TimeOfDay selectedTime;

  // ⭐ AVIS
  List reviews = [];
  final reviewController = TextEditingController();
  int selectedRating = 5;
  String clientName = "";

  @override
  void initState() {
    super.initState();
    try {
      final parts = widget.time.split(":");
      selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (e) {
      selectedTime = const TimeOfDay(hour: 18, minute: 0);
    }
    _loadReviews();
    _loadClientName();
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  Future<void> _loadReviews() async {
    final r = await ApiService.getStoreReviews(widget.storeName);
    if (!mounted) return;
    setState(() => reviews = r);
  }

  Future<void> _loadClientName() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return;
    final res = await ApiService.getProfile(token);
    if (res["success"] == true && res["user"] != null) {
      if (!mounted) return;
      setState(() => clientName = res["user"]["name"]?.toString() ?? "");
    }
  }

  Future<void> _submitReview() async {
    if (reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Écrivez un commentaire")),
      );
      return;
    }
    final ok = await ApiService.createReview(
      clientName.isEmpty ? "Client" : clientName,
      widget.storeName,
      reviewController.text.trim(),
      selectedRating,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? "Avis ajouté ⭐" : "Erreur")),
    );
    if (ok) {
      reviewController.clear();
      setState(() => selectedRating = 5);
      _loadReviews();
    }
  }

  void _reportReview(int reviewId) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Signaler cet avis"),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: "Raison du signalement..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) return;
              final ok = await ApiService.createReport(
                reviewId,
                reasonController.text.trim(),
              );
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(ok ? "Signalé 🚩" : "Erreur")),
              );
            },
            child: const Text("Signaler"),
          ),
        ],
      ),
    );
  }

  // 🛒 AJOUTER AU PANIER
  void _addToCart() {
    CartService.add(
      productId: widget.productId,
      productName: widget.productName,
      price: widget.price,
      storeName: widget.storeName,
    );
    setState(() {}); // 🔴 met à jour le badge
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Ajouté au panier 🛒"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final colors = Theme.of(context).colorScheme;
    final isRtl = lang.current == "ar";

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      // ✅ Material = supprime le souligné jaune sur les Text de la page
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            // ✅ Header
            Container(
              decoration: BoxDecoration(
                color: colors.surface.withOpacity(0.95),
                border: Border(
                  bottom: BorderSide(color: colors.onSurface.withOpacity(0.1)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: colors.onSurface),
                      onPressed: widget.onBack,
                    ),
                    Expanded(
                      child: Text(
                        widget.productName,
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // 🛒 PANIER + badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(Icons.shopping_cart_outlined,
                              color: colors.primary),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const PanierPage()),
                            );
                            setState(() {});
                          },
                        ),
                        if (CartService.count > 0)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${CartService.count}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.image.startsWith('http')
                        ? Image.network(
                            widget.image,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 250,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 50),
                            ),
                          )
                        : Image.asset(
                            widget.image,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        widget.price,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors.secondary,
                          fontFamily: 'PlayfairDisplay',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Location card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        color: colors.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          leading:
                              Icon(Icons.location_on, color: colors.primary),
                          title: Text(
                            lang.t("store_location"),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            widget.storeName,
                            style: TextStyle(
                                color: colors.onSurface.withOpacity(0.6)),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.map, color: colors.primary),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapPage(
                                    lat: widget.lat,
                                    lng: widget.lng,
                                    storeName: widget.storeName,
                                    onBack: () => Navigator.pop(context),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Time picker card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        color: colors.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          leading:
                              Icon(Icons.access_time, color: colors.primary),
                          title: Text(
                            lang.t("pickup_time"),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            selectedTime.format(context),
                            style: TextStyle(
                                color: colors.onSurface.withOpacity(0.6)),
                          ),
                          onTap: pickTime,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Delivery type card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        color: colors.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              RadioListTile(
                                value: "sur_place",
                                groupValue: deliveryType,
                                title: Text(
                                  lang.t("pickup_on_site"),
                                  style: TextStyle(color: colors.onSurface),
                                ),
                                activeColor: colors.primary,
                                onChanged: (value) {
                                  setState(() => deliveryType = value!);
                                },
                              ),
                              RadioListTile(
                                value: "livraison",
                                groupValue: deliveryType,
                                title: Text(
                                  lang.t("delivery_home"),
                                  style: TextStyle(color: colors.onSurface),
                                ),
                                activeColor: colors.primary,
                                onChanged: (value) {
                                  setState(() => deliveryType = value!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ⭐ REVIEWS TITLE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        lang.t("reviews"),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay',
                          color: colors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ⭐ FORMULAIRE AVIS
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        color: colors.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Laisser un avis",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: List.generate(5, (i) {
                                  return IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      i < selectedRating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                    ),
                                    onPressed: () =>
                                        setState(() => selectedRating = i + 1),
                                  );
                                }),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: reviewController,
                                maxLines: 2,
                                style: TextStyle(color: colors.onSurface),
                                decoration: InputDecoration(
                                  hintText: "Votre commentaire...",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: _submitReview,
                                  icon: const Icon(Icons.send, size: 18),
                                  label: const Text("Publier"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colors.primary,
                                    foregroundColor: colors.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ⭐ LISTE DES AVIS
                    if (reviews.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Aucun avis pour le moment",
                          style: TextStyle(
                              color: colors.onSurface.withOpacity(0.6)),
                        ),
                      )
                    else
                      ...reviews.map((r) => _buildReviewCard(r, colors)),

                    const SizedBox(height: 30),

                    // Précédent
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A3B2A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          widget.onConfirm({
                            'productName': widget.productName,
                            'price': widget.price,
                            'oldPrice': widget.oldPrice,
                            'description': widget.description,
                            'storeName': widget.storeName,
                            'pickupTime': selectedTime.format(context),
                            'deliveryType': deliveryType,
                          });
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: Text(
                          lang.t("Précédent"),
                          style: TextStyle(fontSize: 16, color: colors.onPrimary),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Suivant
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A3B2A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                productId: widget.productId,
                                clientId: widget.clientId,
                                productName: widget.productName,
                                price: widget.price,
                                oldPrice: widget.oldPrice,
                                description: widget.description,
                                storeName: widget.storeName,
                                pickupTime: selectedTime.format(context),
                                deliveryType: deliveryType,
                                onBack: () => Navigator.pop(context),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Suivant",
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🛒 AJOUTER AU PANIER
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: _addToCart,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text("Ajouter au panier"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0A3B2A),
                          side: const BorderSide(color: Color(0xFF0A3B2A)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const AppFooter(),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⭐ CARTE D'UN AVIS
  Widget _buildReviewCard(Map review, ColorScheme colors) {
    final rating = int.tryParse((review["rating"] ?? "0").toString()) ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: colors.primary,
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
          title: Text(
            review["client_name"]?.toString() ?? "Client",
            style:
                TextStyle(color: colors.onSurface, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  rating,
                  (i) => const Icon(Icons.star, color: Colors.amber, size: 16),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                review["comment"]?.toString() ?? "",
                style: TextStyle(color: colors.onSurface),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.flag_outlined, color: Colors.red),
            tooltip: "Signaler",
            onPressed: () => _reportReview(review["id"]),
          ),
        ),
      ),
    );
  }
}
