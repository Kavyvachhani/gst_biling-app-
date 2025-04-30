// lib/views/add_product_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  double gstRate = 5.0;

  Future<void> saveProduct() async {
    // Check if fields are not empty
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }
    // Create product object 
    Product product = Product(
      id: DateTime.now().millisecondsSinceEpoch,
      name: nameController.text,
      price: double.tryParse(priceController.text) ?? 0,
      gstRate: gstRate,
    );

    try {
      await DatabaseService.addProduct(product);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Product Saved")));
      // Optionally, print on console to confirm
      print("Product saved successfully: ${product.toMap()}");
      Navigator.pop(context);
    } catch (e) {
      // If any error occurs, show error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error saving product")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Product Name"),
              ),
              TextField(
                controller: priceController,
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: "Price"),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<double>(
                value: gstRate,
                decoration: InputDecoration(labelText: "GST Rate"),
                items: [5.0, 12.0, 18.0, 28.0].map((rate) {
                  return DropdownMenuItem<double>(
                    value: rate,
                    child: Text("$rate%"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    gstRate = value ?? 5.0;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveProduct,
                child: Text("Save Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
