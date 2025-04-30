import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/invoice.dart';
import '../services/database_service.dart';
import '../viewmodels/billing_viewmodel.dart';
import 'detailed_bill_screen.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  bool _initializedSample = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final billingVM = Provider.of<BillingViewModel>(context, listen: false);
    // If the cart is empty and samples haven't been initialized, add them after build.
    if (!_initializedSample && billingVM.selectedProducts.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        billingVM.addProduct(
          Product(id: 201, name: "Milk", price: 50.0, gstRate: 5.0),
        ); // Total ≈ ₹52.50
        billingVM.addProduct(
          Product(id: 202, name: "Bread", price: 30.0, gstRate: 5.0),
        ); // Total ≈ ₹31.50
        billingVM.addProduct(
          Product(id: 203, name: "Butter", price: 80.0, gstRate: 12.0),
        ); // Total ≈ ₹89.60
        billingVM.addProduct(
          Product(id: 204, name: "Eggs", price: 70.0, gstRate: 5.0),
        ); // Total ≈ ₹73.50
        setState(() {
          _initializedSample = true;
        });
      });
    }
  }

  /// Navigates to the Detailed Bill screen with the current invoice details.
  void navigateToDetailedBill(BillingViewModel billingVM) {
    if (billingVM.selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No products available to display")),
      );
      return;
    }
    final invoice = Invoice(
      id: DateTime.now().millisecondsSinceEpoch,
      products: List.from(billingVM.selectedProducts),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailedBillScreen(invoice: invoice)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final billingVM = Provider.of<BillingViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Billing")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the list of products (or a message if empty)
            billingVM.selectedProducts.isEmpty
                ? const Expanded(
                  child: Center(child: Text("No products added")),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: billingVM.selectedProducts.length,
                    itemBuilder: (context, index) {
                      final product = billingVM.selectedProducts[index];
                      return Card(
                        color: Colors.orange.shade50,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Price: ₹${product.price.toStringAsFixed(2)} | GST: ${product.gstRate}%",
                          ),
                          trailing: Text(
                            "Total: ₹${product.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            const Divider(thickness: 2.0),
            // Display aggregated totals
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total CGST: ₹${billingVM.totalCGST.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Total SGST: ₹${billingVM.totalSGST.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Grand Total: ₹${billingVM.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Generate Invoice button: saves invoice and clears the cart.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.receipt_long),
                label: const Text("Generate Invoice"),
                onPressed: () async {
                  if (billingVM.selectedProducts.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("No products selected for billing"),
                      ),
                    );
                    return;
                  }
                  final invoice = Invoice(
                    id: DateTime.now().millisecondsSinceEpoch,
                    products: List.from(billingVM.selectedProducts),
                  );
                  await DatabaseService.addInvoice(invoice);
                  billingVM.clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invoice Generated")),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // View Detailed Bill button: navigates to the detailed view.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.assignment),
                label: const Text("View Detailed Bill"),
                onPressed: () {
                  navigateToDetailedBill(billingVM);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
