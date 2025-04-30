// lib/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/invoice.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'gst_billing.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create products table
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY,
            name TEXT,
            price REAL,
            gstRate REAL
          )
        ''');
        // Create invoices table
        await db.execute('''
          CREATE TABLE invoices(
            id INTEGER PRIMARY KEY,
            productIds TEXT,
            totalAmount REAL
          )
        ''');
      },
    );
  }

  // Insert a product into the database.
  static Future<void> addProduct(Product product) async {
    try {
      final db = await database;
      await db.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("Product saved: ${product.name}");
    } catch (e) {
      print("Error saving product: $e");
      rethrow;
    }
  }

  // Retrieve all products.
  static Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Insert an invoice into the database.
  static Future<void> addInvoice(Invoice invoice) async {
    final db = await database;
    await db.insert(
      'invoices',
      invoice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all invoices.
  static Future<List<Map<String, dynamic>>> getInvoices() async {
    final db = await database;
    return await db.query('invoices');
  }
}
