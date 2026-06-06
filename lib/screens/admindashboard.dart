import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'reportspage.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'categoriespage.dart';
import 'dart:convert';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  static const Color primaryColor = Color(0xFF0A3B2A);
  static const Color backgroundColor = Color(0xFFF5F0E6);

  int clientsCount = 0;
  int storesCount = 0;
  int productsCount = 0;
  int reservationsCount = 0;
  int reportsCount = 0;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final clientsResponse = await http.get(
        Uri.parse('http://localhost:5000/api/clients'),
      );
      final storesResponse = await http.get(
        Uri.parse('http://localhost:5000/api/stores'),
      );
      final productsResponse = await http.get(
        Uri.parse('http://localhost:5000/api/products'),
      );
      final reservationsResponse = await http.get(
        Uri.parse('http://localhost:5000/api/reservations'),
      );
      final reportsResponse = await http.get(
        Uri.parse('http://localhost:5000/api/admin/reports'),
      );

      if (clientsResponse.statusCode == 200) {
        final clients = jsonDecode(clientsResponse.body);
        setState(() => clientsCount = clients.length);
      }
      if (storesResponse.statusCode == 200) {
        final stores = jsonDecode(storesResponse.body);
        setState(() => storesCount = stores.length);
      }
      if (productsResponse.statusCode == 200) {
        final products = jsonDecode(productsResponse.body);
        setState(() => productsCount = products.length);
      }
      if (reservationsResponse.statusCode == 200) {
        final reservations = jsonDecode(reservationsResponse.body);
        setState(() => reservationsCount = reservations.length);
      }
      if (reportsResponse.statusCode == 200) {
        final reports = jsonDecode(reportsResponse.body);
        setState(() => reportsCount = reports.length);
      }
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.surface,
        centerTitle: true,
        title: Text(
          "Admin Dashboard",
          style: TextStyle(
            color: colors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: colors.primary,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Icon(Icons.logout, color: colors.primary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Welcome Admin 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Manage your application easily",
              style: TextStyle(
                fontSize: 14,
                color: colors.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: [
                  // CLIENTS
                  buildCard(
                    context,
                    "Clients",
                    Icons.people_alt_rounded,
                    clientsCount.toString(),
                    "EXPORT CLIENTS CSV",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ClientsPage()),
                      );
                    },
                    () {
                      launchUrl(
                        Uri.parse("http://localhost:5000/api/admin/export-clients"),
                        webOnlyWindowName: '_blank',
                      );
                    },
                  ),

                  // STORES
                  buildCard(
                    context,
                    "Stores",
                    Icons.storefront_rounded,
                    storesCount.toString(),
                    "EXPORT STORES CSV",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StoresPage()),
                      );
                    },
                    () {
                      launchUrl(
                        Uri.parse("http://localhost:5000/api/admin/export-stores"),
                        webOnlyWindowName: '_blank',
                      );
                    },
                  ),

                  // PRODUCTS
                  buildCard(
                    context,
                    "Products",
                    Icons.shopping_bag_rounded,
                    productsCount.toString(),
                    "EXPORT PRODUCTS CSV",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProductsPage()),
                      );
                    },
                    () {
                      launchUrl(
                        Uri.parse("http://localhost:5000/api/admin/export-products"),
                        webOnlyWindowName: '_blank',
                      );
                    },
                  ),

                  // RESERVATIONS
                  buildCard(
                    context,
                    "Reservations",
                    Icons.bookmark_rounded,
                    reservationsCount.toString(),
                    "EXPORT RESERVATIONS CSV",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReservationsPage()),
                      );
                    },
                    () {
                      launchUrl(
                        Uri.parse("http://localhost:5000/api/admin/export-reservations"),
                        webOnlyWindowName: '_blank',
                      );
                    },
                  ),

                  // REPORTS
                  buildCard(
                    context,
                    "Reports",
                    Icons.report_problem_rounded,
                    reportsCount.toString(),
                    "",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReportsPage()),
                      );
                    },
                    null,
                  ),

                  // STATISTICS
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatisticsPage(
                            clients: clientsCount,
                            stores: storesCount,
                            products: productsCount,
                            reservations: reservationsCount,
                            reports: reportsCount,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bar_chart_rounded, size: 38, color: primaryColor),
                          const SizedBox(height: 12),
                          const Text(
                            "Statistics",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              fontFamily: 'PlayfairDisplay',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildCard(
    BuildContext context,
    String title,
    IconData icon,
    String count,
    String exportText,
    VoidCallback onTap,
    VoidCallback? onExport,
  ) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: primaryColor),
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.primary,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
            const SizedBox(height: 8),
            if (count.isNotEmpty)
              Text(
                count,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            const SizedBox(height: 14),
            if (onExport != null && exportText.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton.icon(
                  onPressed: onExport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.download, size: 16),
                  label: Text(
                    exportText,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ================= CLIENTS PAGE =================
class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const DetailsPage(title: "Clients", endpoint: "clients", dataKey: "clients");
  }
}

// ================= STORES PAGE =================
class StoresPage extends StatelessWidget {
  const StoresPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const DetailsPage(title: "Stores", endpoint: "stores", dataKey: "stores");
  }
}

// ================= PRODUCTS PAGE =================
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const DetailsPage(title: "Products", endpoint: "products", dataKey: "products");
  }
}

// ================= RESERVATIONS PAGE =================
class ReservationsPage extends StatelessWidget {
  const ReservationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const DetailsPage(title: "Reservations", endpoint: "reservations", dataKey: "reservations");
  }
}

// ================= STATISTICS PAGE =================
class StatisticsPage extends StatelessWidget {
  final int clients;
  final int stores;
  final int products;
  final int reservations;
  final int reports;

  const StatisticsPage({
    super.key,
    required this.clients,
    required this.stores,
    required this.products,
    required this.reservations,
    required this.reports,
  });

  static const Color primaryColor = Color(0xFF0A3B2A);
  static const Color backgroundColor = Color(0xFFF5F0E6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryColor),
        title: const Text(
          "Statistics",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            ListTile(
              title: const Text("Clients"),
              trailing: Text(clients.toString(),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            ListTile(
              title: const Text("Stores"),
              trailing: Text(stores.toString(),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            ListTile(
              title: const Text("Products"),
              trailing: Text(products.toString(),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            ListTile(
              title: const Text("Reservations"),
              trailing: Text(reservations.toString(),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            ListTile(
              title: const Text("Reports"),
              trailing: Text(reports.toString(),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DETAILS PAGE =================
class DetailsPage extends StatefulWidget {
  final String title;
  final String endpoint;
  final String dataKey;

  const DetailsPage({
    super.key,
    required this.title,
    required this.endpoint,
    required this.dataKey,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  static const Color primaryColor = Color(0xFF0A3B2A);
  static const Color backgroundColor = Color(0xFFF5F0E6);

  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:5000/api/${widget.endpoint}"),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (data is List) {
            items = data;
          } else if (data is Map) {
            items = data[widget.dataKey] ?? [];
          }
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("ERROR = $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryColor),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(child: Text("No data found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["name"]?.toString() ??
                                item["product_name"]?.toString() ??
                                item["client_name"]?.toString() ??
                                item["store_name"]?.toString() ??
                                "No Name",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),

                          if (item["email"] != null) Text("📧 ${item["email"]}"),
                          if (item["phone"] != null) Text("📞 ${item["phone"]}"),
                          if (item["category"] != null) Text("🏪 ${item["category"]}"),
                          if (item["price"] != null) Text("💰 ${item["price"]}"),
                          if (item["reservation_date"] != null)
                            Text("📅 ${item["reservation_date"]}"),

                          // ================= DELETE CLIENT =================
                          if (widget.endpoint == "clients") ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  final response = await http.delete(
                                    Uri.parse(
                                      "http://localhost:5000/api/admin/delete-client/${item["id"]}",
                                    ),
                                  );
                                  if (response.statusCode == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Client deleted ❌")),
                                    );
                                    fetchData();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Delete failed")),
                                    );
                                  }
                                },
                                child: const Text("DELETE CLIENT"),
                              ),
                            ),
                          ],

                          // ================= DELETE PRODUCT =================
                          if (widget.endpoint == "products") ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  final response = await http.delete(
                                    Uri.parse(
                                      "http://localhost:5000/api/admin/delete-product/${item["id"]}",
                                    ),
                                  );
                                  if (response.statusCode == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Product deleted ❌")),
                                    );
                                    fetchData();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Delete failed")),
                                    );
                                  }
                                },
                                child: const Text("DELETE PRODUCT"),
                              ),
                            ),
                          ],

                          // ================= VALIDATE PRODUCT ================= 🆕
                          if (widget.endpoint == "products" &&
                              item["is_validated"] == false) ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  final response = await http.put(
                                    Uri.parse(
                                      "http://localhost:5000/api/admin/validate-product/${item["id"]}",
                                    ),
                                  );
                                  if (response.statusCode == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Product validated ✅")),
                                    );
                                    fetchData();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Validation failed")),
                                    );
                                  }
                                },
                                child: const Text("VALIDATE PRODUCT"),
                              ),
                            ),
                          ],

                          // ================= PRODUCT VALIDATED ================= 🆕
                          if (widget.endpoint == "products" &&
                              item["is_validated"] == true) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "✅ VALIDATED",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],

                          // ================= DELETE RESERVATION =================
                          if (widget.endpoint == "reservations") ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  final response = await http.delete(
                                    Uri.parse(
                                      "http://localhost:5000/api/admin/delete-reservation/${item["id"]}",
                                    ),
                                  );
                                  if (response.statusCode == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Reservation deleted ❌")),
                                    );
                                    fetchData();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Delete failed")),
                                    );
                                  }
                                },
                                child: const Text("DELETE RESERVATION"),
                              ),
                            ),
                          ],

                          // ================= VALIDATE STORE =================
                          if (widget.endpoint == "stores" &&
                              item["is_validated"] == false) ...[
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  final response = await http.put(
                                    Uri.parse(
                                      "http://localhost:5000/api/admin/validate-store/${item["id"]}",
                                    ),
                                  );
                                  if (response.statusCode == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Store validated ✅")),
                                    );
                                    fetchData();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Validation failed")),
                                    );
                                  }
                                },
                                child: const Text("VALIDATE STORE"),
                              ),
                            ),
                          ],

                          // ================= DELETE STORE =================
                          if (widget.endpoint == "stores") ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  final response = await http.delete(
                                    Uri.parse(
                                      "http://localhost:5000/api/admin/delete-store/${item["id"]}",
                                    ),
                                  );
                                  if (response.statusCode == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Store deleted ❌")),
                                    );
                                    fetchData();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Delete failed")),
                                    );
                                  }
                                },
                                child: const Text("DELETE STORE"),
                              ),
                            ),
                          ],

                          // ================= STORE VALIDATED =================
                          if (widget.endpoint == "stores" &&
                              item["is_validated"] == true) ...[
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "✅ VALIDATED",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
