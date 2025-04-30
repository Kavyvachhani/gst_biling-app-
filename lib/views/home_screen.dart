// lib/views/home_screen.dart
import 'package:flutter/material.dart';
import 'add_product_screen.dart'; // Make sure only one of these files is imported
import 'billing_screen.dart';
import 'invoice_history_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GST Billing App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BillingScreen()),
                );
              },
              child: Text("Billing"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Use the correct constructor call for AddProductScreen.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddProductScreen()),
                );
              },
              child: Text("Add Product"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => InvoiceHistoryScreen()),
                );
              },
              child: Text("Invoice History"),
            ),
          ],
        ),
      ),
    );
  }
}
