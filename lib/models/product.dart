// lib/models/product.dart
class Product {
  final int id;
  final String name;
  final double price;
  final double gstRate; // GST rate in percentage

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.gstRate,
  });

  // CGST and SGST are computed by dividing the GST amount equally.
  double get cgst => (price * gstRate) / 200; // (Price * (gstRate/100))/2
  double get sgst => (price * gstRate) / 200;
  double get totalPrice => price + cgst + sgst;

  // Convert product to map for storing in SQLite
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price, 'gstRate': gstRate};
  }

  // Create a Product instance from a map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      gstRate: map['gstRate'],
    );
  }
}
