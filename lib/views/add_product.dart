import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_service.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  double gstRate = 5.0;

  void saveProduct() async {
    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch,
      name: nameController.text,
      price: double.parse(priceController.text),
      gstRate: gstRate,
    );
    await DatabaseService.addProduct(product);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Product Name")),
            TextField(controller: priceController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Price")),
            DropdownButton<double>(
              value: gstRate,
              items: [5.0, 12.0, 18.0, 28.0].map((rate) => DropdownMenuItem(value: rate, child: Text("$rate% GST"))).toList(),
              onChanged: (value) => setState(() => gstRate = value!),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: saveProduct, child: Text("Save Product"))
          ],
        ),
      ),
    );
  }
}
