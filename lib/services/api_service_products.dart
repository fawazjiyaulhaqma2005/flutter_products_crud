import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ApiServiceProducts {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.0.102:8090/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // MENAMPILKAN SEMUA PRODUK
  Future<ProductsResponse> getAllProducts({
    int limit = 30,
    int skip = 0,
  }) async {
    final response = await _dio.get('/products.php');

    final json = Map<String, dynamic>.from(response.data as Map);

    final products = (json['data'] as List)
        .map((e) => Product.fromJson(
              Map<String, dynamic>.from(e),
            ))
        .toList();

    return ProductsResponse(
      products: products,
      total: products.length,
      skip: 0,
      limit: products.length,
    );
  }

  // MENAMPILKAN DETAIL PRODUK
  Future<Product> getProduct(int id) async {
    final response = await _dio.get(
      '/products.php',
      queryParameters: {'id': id},
    );

    return Product.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }

  // MENAMBAHKAN PRODUK
  Future<Product> addProduct(Map<String, dynamic> data) async {
    final response = await _dio.post(
      '/products.php',
      data: data,
    );

    final json = Map<String, dynamic>.from(response.data as Map);

    return getProduct(
      int.parse(json['data']['id'].toString()),
    );
  }

  // MENGEDIT PRODUK
  Future<Product> updateProduct(
    int id,
    Map<String, dynamic> data,
  ) async {
    await _dio.put(
      '/products.php',
      queryParameters: {'id': id},
      data: data,
    );

    return getProduct(id);
  }

  // MENGHAPUS PRODUK
  Future<Map<String, dynamic>> deleteProduct(int id) async {
    final response = await _dio.delete(
      '/products.php',
      queryParameters: {'id': id},
    );

    return Map<String, dynamic>.from(response.data as Map);
  }
}
