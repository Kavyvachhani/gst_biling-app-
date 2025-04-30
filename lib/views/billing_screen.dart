// lib/views/billing_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/billing_viewmodel.dart';
import '../models/invoice.dart';
import '../services/database_service.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billingVM = Provider.of<BillingViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Billing"),
      ),
      body: Column(
        children: [
          Expanded(
            child: billingVM.selectedProducts.isEmpty
                ? Center(child: Text("No products added"))
                : ListView.builder(
                    itemCount: billingVM.selectedProducts.length,
                    itemBuilder: (context, index) {
                      final product = billingVM.selectedProducts[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text("Price: ₹${product.price} | GST: ${product.gstRate}%"),
                        trailing: Text("Total: ₹${product.totalPrice.toStringAsFixed(2)}"),
                      );
                    },
                  ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Total CGST: ₹${billingVM.totalCGST.toStringAsFixed(2)}"),
                Text("Total SGST: ₹${billingVM.totalSGST.toStringAsFixed(2)}"),
                Text("Grand Total: ₹${billingVM.totalPrice.toStringAsFixed(2)}"),
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              if (billingVM.selectedProducts.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No products selected for billing")));
                return;
              }
              // Generate invoice and save in DB.
              var invoice = Invoice(
                id: DateTime.now().millisecondsSinceEpoch,
                products: billingVM.selectedProducts,
              );
              await DatabaseService.addInvoice(invoice);
              billingVM.clearCart();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Invoice Generated")));
            },
            child: Text("Generate Invoice"),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
