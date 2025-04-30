// lib/viewmodels/billing_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class BillingViewModel extends ChangeNotifier {
  final List<Product> _selectedProducts = [];

  List<Product> get selectedProducts => _selectedProducts;

  // Add product to the billing cart
  void addProduct(Product product) {
    _selectedProducts.add(product);
    notifyListeners();
  }

  // Clear the billing cart
  void clearCart() {
    _selectedProducts.clear();
    notifyListeners();
  }

  double get totalCGST => _selectedProducts.fold(0.0, (sum, product) => sum + product.cgst);
  double get totalSGST => _selectedProducts.fold(0.0, (sum, product) => sum + product.sgst);
  double get totalPrice => _selectedProducts.fold(0.0, (sum, product) => sum + product.totalPrice);
}
