import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:http/http.dart' as http;

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {

  static const Color primaryColor = Color(0xFF0A3B2A);
  static const Color backgroundColor = Color(0xFFF5F0E6);

  List reports = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {

    try {

      final response = await http.get(
        Uri.parse(
          "${ApiService.baseUrl}/admin/reports",
        ),
      );

      if (response.statusCode == 200) {

        setState(() {

          reports = jsonDecode(response.body);

          isLoading = false;
        });
      }

    } catch (e) {

      print(e);

      setState(() {
        isLoading = false;
      });
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

        title: const Text(

          "Reports Moderation",

          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          : reports.isEmpty
              ? const Center(
                  child: Text("No reports"),
                )

              : ListView.builder(

                  padding: const EdgeInsets.all(16),

                  itemCount: reports.length,

                  itemBuilder: (context, index) {

                    final report = reports[index];

                    return Container(

                      margin: const EdgeInsets.only(bottom: 16),

                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius: BorderRadius.circular(20),

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
                            "🚨 ${report["reason"]}",

                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "💬 ${report["comment"]}",
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "👤 ${report["client_name"]}",
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "🏪 ${report["store_name"]}",
                          ),

                          const SizedBox(height: 18),

                          // DELETE REPORT

                          SizedBox(

                            width: double.infinity,

                            child: ElevatedButton(

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),

                              onPressed: () async {

                                final response =
                                    await http.delete(

                                  Uri.parse(
                                    "${ApiService.baseUrl}/admin/delete-report/${report["id"]}",
                                  ),
                                );

                                if (response.statusCode == 200) {

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(

                                    const SnackBar(
                                      content: Text(
                                        "Report deleted",
                                      ),
                                    ),
                                  );

                                  fetchReports();
                                }
                              },

                              child: const Text(
                                "DELETE REPORT",
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}