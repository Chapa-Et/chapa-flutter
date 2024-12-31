import 'dart:developer';
import 'dart:io' as io;
import 'package:shopping_cart_app/model/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE cart('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'productId VARCHAR UNIQUE, '
      'productName TEXT, '
      'initialPrice INTEGER, '
      'productPrice INTEGER, '
      'quantity INTEGER, '
      'unitTag TEXT, '
      'image TEXT)',
    );
  }

  Future<Cart> insert(Cart cart) async {
    final dbClient = await database;
    try {
      await dbClient.insert(
        'cart',
        cart.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      log('Error inserting cart: $e');
    }
    return cart;
  }

  Future<Cart> addToCart(Cart cart) async {
    final dbClient = await database;
    try {
      List<Map<String, dynamic>> existingProduct = await dbClient.query(
        'cart',
        where: 'productId = ?',
        whereArgs: [cart.productId],
      );

      if (existingProduct.isEmpty) {
        await dbClient.insert('cart', cart.toMap());
      } else {
        final newQuantity =
            (cart.quantity?.value ?? 0) + existingProduct[0]['quantity'];
        await dbClient.update(
          'cart',
          {'quantity': newQuantity},
          where: 'productId = ?',
          whereArgs: [cart.productId],
        );
      }
    } catch (e) {
      log('Error in addToCart: $e');
    }
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    final dbClient = await database;
    try {
      final queryResult = await dbClient.query('cart');
      return queryResult.map((result) => Cart.fromMap(result)).toList();
    } catch (e) {
      log('Error fetching cart list: $e');
      return [];
    }
  }

  Future<int> deleteCartItem(int id) async {
    final dbClient = await database;
    try {
      return await dbClient.delete('cart', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      log('Error deleting cart item: $e');
      return 0;
    }
  }

  Future<int> updateQuantity(Cart cart) async {
    final dbClient = await database;
    try {
      return await dbClient.update(
        'cart',
        cart.quantityMap(),
        where: 'productId = ?',
        whereArgs: [cart.productId],
      );
    } catch (e) {
      log('Error updating quantity: $e');
      return 0;
    }
  }

  /// Retrieve cart items by their ID
  Future<List<Cart>> getCartId(int id) async {
    final dbClient = await database;
    try {
      final queryIdResult =
          await dbClient.query('cart', where: 'id = ?', whereArgs: [id]);
      return queryIdResult.map((e) => Cart.fromMap(e)).toList();
    } catch (e) {
      log('Error fetching cart by ID: $e');
      return [];
    }
  }
}
