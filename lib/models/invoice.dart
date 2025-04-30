// lib/models/invoice.dart
import 'product.dart';

class Invoice {
  final int id;
  final List<Product> products;

  Invoice({required this.id, required this.products});

  double get totalCGST =>
      products.fold(0.0, (sum, product) => sum + product.cgst);
  double get totalSGST =>
      products.fold(0.0, (sum, product) => sum + product.sgst);
  double get totalPrice =>
      products.fold(0.0, (sum, product) => sum + product.totalPrice);

  // Convert the invoice to map for saving in database.
  // For a simplified implementation, product IDs are stored as a comma-separated string.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productIds': products.map((p) => p.id).join(','),
      'totalAmount': totalPrice,
    };
  }
}
