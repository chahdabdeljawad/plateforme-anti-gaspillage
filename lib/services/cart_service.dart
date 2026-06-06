class CartService {
  static final List<Map<String, dynamic>> items = [];

  static void add({
    required int productId,
    required String productName,
    required String price,
    required String storeName,
  }) {
    final i = items.indexWhere((e) => e["productId"] == productId);
    if (i >= 0) {
      items[i]["quantity"] = (items[i]["quantity"] as int) + 1;
    } else {
      items.add({
        "productId": productId,
        "productName": productName,
        "price": price,
        "storeName": storeName,
        "quantity": 1,
      });
    }
  }

  // ➕
  static void increment(int productId) {
    final i = items.indexWhere((e) => e["productId"] == productId);
    if (i >= 0) {
      items[i]["quantity"] = (items[i]["quantity"] as int) + 1;
    }
  }

  // ➖ (يحذف إذا وصل 0)
  static void decrement(int productId) {
    final i = items.indexWhere((e) => e["productId"] == productId);
    if (i >= 0) {
      final q = (items[i]["quantity"] as int) - 1;
      if (q <= 0) {
        items.removeAt(i);
      } else {
        items[i]["quantity"] = q;
      }
    }
  }

  static void remove(int productId) {
    items.removeWhere((e) => e["productId"] == productId);
  }

  static void clear() => items.clear();

  static int get count =>
      items.fold(0, (s, e) => s + (e["quantity"] as int));

  static double get total {
    double t = 0;
    for (final e in items) {
      final p = double.tryParse(
              e["price"].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ??
          0;
      t += p * (e["quantity"] as int);
    }
    return t;
  }
}