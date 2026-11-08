
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';

class DetailProductScreen extends StatefulWidget {
  final int id;

  const DetailProductScreen({
    super.key,
    required this.id,
  });

  @override
  State<DetailProductScreen> createState() =>
      _DetailProductScreenState();
}

class _DetailProductScreenState
    extends State<DetailProductScreen> {
  late Future<Product?> futureProduct;

  @override
  void initState() {
    super.initState();

    futureProduct =
        context.read<ProductProvider>().fetchProduct(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: FutureBuilder<Product?>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Detail produk gagal dimuat.'),
            );
          }

          final p = snapshot.data;

          if (p == null) {
            return const Center(
              child: Text('Produk tidak ditemukan.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.all(18),
                child: CachedNetworkImage(
                  imageUrl: p.thumbnail,
                  fit: BoxFit.contain,
                  errorWidget: (_, __, ___) =>
                      const Icon(
                    Icons.image_not_supported_outlined,
                    size: 60,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                p.category.isEmpty
                    ? 'TANPA KATEGORI'
                    : p.category.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                p.title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                '\$${p.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                p.description.isEmpty
                    ? 'Tidak ada deskripsi produk.'
                    : p.description,
                style: const TextStyle(height: 1.5),
              ),

              const SizedBox(height: 20),

              detailRow('ID Produk', p.id.toString()),
              detailRow(
                'Kategori',
                p.category.isEmpty ? '-' : p.category,
              ),
              detailRow('Harga', money(p.price)),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: () => context.push(
                  '/edit/${p.id}',
                  extra: p,
                ),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Produk'),
              ),
            ],
          );
        },
      ),
    );
  }

  String money(double price) =>
      '\$${price.toStringAsFixed(2)}';

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
