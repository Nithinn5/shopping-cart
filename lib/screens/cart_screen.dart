
import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final void Function(int productId) onIncrease;
  final void Function(int productId) onDecrease;
  final void Function(int productId) onRemove;
  final VoidCallback onClear;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    required this.onClear,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get totalPrice {
    return widget.cartItems.fold(
      0,
          (sum, item) => sum + item.subtotal,
    );
  }

  int get totalItems {
    return widget.cartItems.fold(
      0,
          (sum, item) => sum + item.quantity,
    );
  }

  void increaseQuantity(int productId) {
    widget.onIncrease(productId);
    setState(() {});
  }

  void decreaseQuantity(int productId) {
    widget.onDecrease(productId);
    setState(() {});
  }

  void removeItem(CartItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Product?'),
          content: Text(
            'Are you sure you want to remove ${item.product.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      widget.onRemove(item.product.id);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.product.name} removed from cart'),
        ),
      );
    }
  }

  void clearCart() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Cart?'),
          content: const Text(
            'Are you sure you want to remove all products?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      widget.onClear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shopping Cart'),
          actions: [
            if (widget.cartItems.isNotEmpty)
              IconButton(
                onPressed: clearCart,
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Clear Cart',
              ),
          ],
        ),
        body: widget.cartItems.isEmpty
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Your cart is empty!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 8),
              Text('Add some products to get started.'),
            ],
          ),
        )
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];

                  return CartItemCard(
                    key: ValueKey(item.product.id),
                    item: item,
                    onIncrease: () => increaseQuantity(item.product.id),
                    onDecrease: () {
                      if (item.quantity > 1) {
                        decreaseQuantity(item.product.id);
                      } else {
                        removeItem(item);
                      }
                    },
                    onRemove: () {
                      removeItem(item);
                    },
                  );
                },
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Total Items: $totalItems',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Grand Total: ₹${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
