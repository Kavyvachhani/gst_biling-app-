import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  double gstRate = 5.0;

  Future<void> saveProduct() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch,
      name: nameController.text,
      price: double.tryParse(priceController.text) ?? 0,
      gstRate: gstRate,
    );

    try {
      await DatabaseService.addProduct(product);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Product Saved")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error saving product")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<double>(
              value: gstRate,
              decoration: const InputDecoration(
                labelText: 'GST Rate',
                border: OutlineInputBorder(),
              ),
              items:
                  [5.0, 12.0, 18.0, 28.0]
                      .map(
                        (rate) => DropdownMenuItem<double>(
                          value: rate,
                          child: Text("$rate%"),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  gstRate = value ?? 5.0;
                });
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveProduct,
                child: const Text('Save Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
