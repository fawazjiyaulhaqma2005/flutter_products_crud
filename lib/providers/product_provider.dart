
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service_products.dart';

class ProductProvider extends ChangeNotifier {
  final ApiServiceProducts _api = ApiServiceProducts();

  List<Product> _products = [];
  bool _loading = false;
  String? _error;

  List<Product> get products => _products;
  bool get loading => _loading;
  String? get error => _error;

  // MENAMPILKAN SEMUA PRODUK
  Future<void> fetchProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _api.getAllProducts();
      _products = result.products;
    } catch (e) {
      _error = 'Gagal mengambil data produk: $e';
      debugPrint(_error);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // MENAMPILKAN DETAIL PRODUK
  Future<Product?> fetchProduct(int id) async {
    try {
      return await _api.getProduct(id);
    } catch (e) {
      debugPrint('Gagal mengambil detail produk: $e');
      return null;
    }
  }

  // MENAMBAHKAN PRODUK
  Future<bool> addProduct(Map<String, dynamic> data) async {
    try {
      await _api.addProduct(data);
      await fetchProducts();
      return true;
    } catch (e) {
      debugPrint('Gagal menambahkan produk: $e');
      return false;
    }
  }

  // MENGEDIT PRODUK
  Future<bool> updateProduct(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      await _api.updateProduct(id, data);
      await fetchProducts();
      return true;
    } catch (e) {
      debugPrint('Gagal mengedit produk: $e');
      return false;
    }
  }

  // MENGHAPUS PRODUK
  Future<bool> deleteProduct(int id) async {
    try {
      await _api.deleteProduct(id);
      await fetchProducts();
      return true;
    } catch (e) {
      debugPrint('Gagal menghapus produk: $e');
      return false;
    }
  }
}
