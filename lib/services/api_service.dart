import '../models/product.dart';

class ApiService {
  static Future<List<Product>> fetchProducts() async {
    // Simulate a network delay.
    await Future.delayed(const Duration(seconds: 2));
    return [
      Product(id: 101, name: "API Product 1", price: 150.0, gstRate: 18.0),
      Product(id: 102, name: "API Product 2", price: 250.0, gstRate: 12.0),
      Product(id: 103, name: "API Product 3", price: 350.0, gstRate: 5.0),
    ];
  }
}
