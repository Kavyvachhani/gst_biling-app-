class Product {
  final int id;
  final String name;
  final double price;
  final double gstRate; // in percentage

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.gstRate,
  });

  // CGST and SGST (each calculated as half of GST amount)
  double get cgst => (price * gstRate) / 200;
  double get sgst => (price * gstRate) / 200;
  double get totalPrice => price + cgst + sgst;

  // Convert to Map (for storage)
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price, 'gstRate': gstRate};
  }

  // Create Product from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      gstRate: map['gstRate'],
    );
  }
}
