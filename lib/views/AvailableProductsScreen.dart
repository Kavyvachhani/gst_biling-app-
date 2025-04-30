import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/invoice.dart';
import '../services/database_service.dart';
import '../viewmodels/billing_viewmodel.dart';

class AvailableProductsScreen extends StatelessWidget {
  // A static list of available products with random names and details.
  final List<Product> availableProducts = [
    Product(id: 301, name: "Milk", price: 50.0, gstRate: 5.0),
    Product(id: 302, name: "Bread", price: 30.0, gstRate: 5.0),
    Product(id: 303, name: "Butter", price: 80.0, gstRate: 12.0),
    Product(id: 304, name: "Eggs", price: 70.0, gstRate: 5.0),
    Product(id: 305, name: "Cheese", price: 120.0, gstRate: 12.0),
    Product(id: 306, name: "Juice", price: 60.0, gstRate: 5.0),
    // You can add more products here if desired.
  ];

  AvailableProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the current instance of BillingViewModel via Provider.
    final billingVM = Provider.of<BillingViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Available Products")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display a list of available products.
            Expanded(
              child: ListView.builder(
                itemCount: availableProducts.length,
                itemBuilder: (context, index) {
                  final product = availableProducts[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Price: ₹${product.price.toStringAsFixed(2)} | GST: ${product.gstRate}%",
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.deepOrange, // updated parameter
                        ),
                        onPressed: () {
                          // Add the product to the billing cart.
                          billingVM.addProduct(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${product.name} added to bill"),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const Text("Add"),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // "Generate Bill" button at the bottom.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepOrange, // updated parameter from 'primary'
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.receipt),
                label: const Text(
                  "Generate Bill",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if (billingVM.selectedProducts.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("No products selected for billing"),
                      ),
                    );
                    return;
                  }
                  // Construct an invoice from the selected products.
                  final invoice = Invoice(
                    id: DateTime.now().millisecondsSinceEpoch,
                    products: List.from(billingVM.selectedProducts),
                  );
                  // Save the invoice using the database service.
                  await DatabaseService.addInvoice(invoice);
                  // Clear the billing cart.
                  billingVM.clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Bill Generated")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
