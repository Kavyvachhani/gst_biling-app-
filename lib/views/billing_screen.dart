import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/invoice.dart';
import '../services/database_service.dart';
import '../viewmodels/billing_viewmodel.dart';

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
    // If the billing cart is empty, load static sample products.
    if (!_initializedSample && billingVM.selectedProducts.isEmpty) {
      billingVM.addProduct(
        Product(id: 201, name: "Static Product A", price: 200.0, gstRate: 18.0),
      );
      billingVM.addProduct(
        Product(id: 202, name: "Static Product B", price: 500.0, gstRate: 12.0),
      );
      billingVM.addProduct(
        Product(id: 203, name: "Static Product C", price: 300.0, gstRate: 5.0),
      );
      _initializedSample = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final billingVM = Provider.of<BillingViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Billing')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
                        margin: const EdgeInsets.symmetric(vertical: 8),
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
            const Divider(thickness: 2),
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
          ],
        ),
      ),
    );
  }
}
