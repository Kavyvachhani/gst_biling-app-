import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductApiScreen extends StatefulWidget {
  const ProductApiScreen({super.key});

  @override
  State<ProductApiScreen> createState() => _ProductApiScreenState();
}

class _ProductApiScreenState extends State<ProductApiScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("API Products")),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    "Price: ₹${product.price.toStringAsFixed(2)} | GST: ${product.gstRate}%",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
