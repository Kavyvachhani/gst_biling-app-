import 'package:flutter/material.dart';
import '../services/database_service.dart';

class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({Key? key}) : super(key: key);

  @override
  _InvoiceHistoryScreenState createState() => _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends State<InvoiceHistoryScreen> {
  late Future<List<Map<String, dynamic>>> _invoicesFuture;
  // Define some static sample invoices.
  final List<Map<String, dynamic>> _sampleInvoices = [
    {
      'id': 1001,
      'productIds': "201,202",
      'totalAmount':
          236.0 +
          560.0, // calculated totals for Static Product A (236) and B (560)
    },
    {
      'id': 1002,
      'productIds': "203",
      'totalAmount': 315.0, // for Static Product C: 300 + 7.5 + 7.5
    },
  ];

  @override
  void initState() {
    super.initState();
    _invoicesFuture = DatabaseService.getInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invoice History")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _invoicesFuture,
        builder: (context, snapshot) {
          List<Map<String, dynamic>> invoices;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            invoices = snapshot.data!;
          } else {
            // Use static sample invoices if database is empty.
            invoices = _sampleInvoices;
          }
          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return Card(
                color: Colors.orange.shade100,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: const Icon(Icons.receipt),
                  title: Text("Invoice #${invoice['id']}"),
                  subtitle: Text("Total: ₹${invoice['totalAmount']}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
