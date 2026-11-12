
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onCartTap;
  final int totalItems;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onCartTap,
    required this.totalItems,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late int _totalItems;

  @override
  void initState() {
    super.initState();
    _totalItems = widget.totalItems;
  }

  // Add product and update cart count immediately.
  void _handleAddToCart() {
    widget.onAddToCart();

    setState(() {
      _totalItems++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            onPressed: widget.onCartTap,
            icon: Badge(
              backgroundColor: Colors.red,
              label: Text('$_totalItems'),
              child: const Icon(Icons.shopping_cart),
            ),
            tooltip: 'Shopping Cart',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: widget.product.imageUrl,
              height: 280,
              width: double.infinity,
              fit: BoxFit.contain,
              memCacheWidth: 600,
              maxWidthDiskCache: 600,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
              const Icon(
                Icons.image_not_supported,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              '₹${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleAddToCart,
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
