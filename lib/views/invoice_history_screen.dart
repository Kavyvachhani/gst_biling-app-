// lib/views/invoice_history_screen.dart
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({Key? key}) : super(key: key);

  @override
  _InvoiceHistoryScreenState createState() => _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends State<InvoiceHistoryScreen> {
  late Future<List<Map<String, dynamic>>> invoices;

  @override
  void initState() {
    super.initState();
    invoices = DatabaseService.getInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice History"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: invoices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) 
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.isEmpty) 
            return Center(child: Text("No invoices found"));

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final invoice = data[index];
              return ListTile(
                title: Text("Invoice #${invoice['id']}"),
                subtitle: Text("Total: ₹${invoice['totalAmount']}"),
              );
            },
          );
        },
      ),
    );
  }
}
