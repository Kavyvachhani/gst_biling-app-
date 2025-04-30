import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/invoice.dart';
import '../models/product.dart';

class DetailedBillScreen extends StatelessWidget {
  final Invoice invoice;
  const DetailedBillScreen({Key? key, required this.invoice}) : super(key: key);

  /// Builds a detailed multiline string containing the bill breakdown.
  String get billDetails {
    StringBuffer buffer = StringBuffer();

    // Header
    buffer.writeln("******** Detailed Bill ********");
    buffer.writeln("Invoice ID: ${invoice.id}");
    buffer.writeln("");

    // Iterate through products
    for (Product p in invoice.products) {
      buffer.writeln("Product: ${p.name}");
      buffer.writeln("  Price    : ₹${p.price.toStringAsFixed(2)}");
      buffer.writeln("  GST Rate : ${p.gstRate}%");
      buffer.writeln("  CGST     : ₹${p.cgst.toStringAsFixed(2)}");
      buffer.writeln("  SGST     : ₹${p.sgst.toStringAsFixed(2)}");
      buffer.writeln("  Total    : ₹${p.totalPrice.toStringAsFixed(2)}");
      buffer.writeln("-------------------------------------");
    }

    // Totals
    double totalCGST = invoice.products.fold(0.0, (sum, p) => sum + p.cgst);
    double totalSGST = invoice.products.fold(0.0, (sum, p) => sum + p.sgst);
    double grandTotal = invoice.totalPrice;

    buffer.writeln("Total CGST  : ₹${totalCGST.toStringAsFixed(2)}");
    buffer.writeln("Total SGST  : ₹${totalSGST.toStringAsFixed(2)}");
    buffer.writeln("Grand Total : ₹${grandTotal.toStringAsFixed(2)}");
    buffer.writeln("*******************************");

    return buffer.toString();
  }

  /// Copies the bill details to the clipboard.
  void _copyBill(BuildContext context) {
    Clipboard.setData(ClipboardData(text: billDetails));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bill details copied to clipboard")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detailed Bill")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Display the detailed bill text in a scrollable view.
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  billDetails,
                  style: const TextStyle(fontSize: 16, fontFamily: 'Courier'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Button to copy the bill details.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text("Copy Bill"),
                onPressed: () => _copyBill(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
