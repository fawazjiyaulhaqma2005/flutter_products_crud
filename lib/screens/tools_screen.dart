
import 'package:flutter/material.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengujian Endpoint API'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pengujian API Produk menggunakan PHP dan MySQL.',
            style: TextStyle(height: 1.5),
          ),
          const SizedBox(height: 16),

          _section(
            'GET Products',
            'Mengambil seluruh data produk dari database.',
            'GET /api/products.php',
            Icons.list_alt,
          ),

          _section(
            'GET Detail Product',
            'Mengambil detail produk berdasarkan ID.',
            'GET /api/products.php?id=1',
            Icons.visibility,
          ),

          _section(
            'POST Product',
            'Menambahkan produk baru ke database.',
            'POST /api/products.php',
            Icons.add_circle_outline,
          ),

          _section(
            'PUT Product',
            'Mengubah data produk berdasarkan ID.',
            'PUT /api/products.php?id=1',
            Icons.edit,
          ),

          _section(
            'DELETE Product',
            'Menghapus produk berdasarkan ID.',
            'DELETE /api/products.php?id=1',
            Icons.delete_outline,
          ),

          const SizedBox(height: 16),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catatan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'API ini menggunakan PHP sebagai backend '
                    'dan MySQL sebagai database. Data produk '
                    'yang ditambahkan, diedit, atau dihapus '
                    'akan diproses melalui database.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(
    String title,
    String description,
    String endpoint,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description),
              const SizedBox(height: 6),
              Text(
                endpoint,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
