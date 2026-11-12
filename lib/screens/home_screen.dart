
import 'package:flutter/material.dart';
import 'package:shopping_application/screens/product_details_screen.dart';

import '../data/product_data.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CartItem> cartItems = [];

  // Add product to cart
  void addToCart(Product product) {
    setState(() {
      final index = cartItems.indexWhere(
            (item) => item.product.id == product.id,
      );

      if (index != -1) {
        cartItems[index].quantity++;
      } else {
        cartItems.add(
          CartItem(product: product),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Increase product quantity
  void increaseQuantity(int productId) {
    setState(() {
      final index = cartItems.indexWhere(
            (item) => item.product.id == productId,
      );

      if (index != -1) {
        cartItems[index].quantity++;
      }
    });
  }

  // Decrease product quantity
  void decreaseQuantity(int productId) {
    setState(() {
      final index = cartItems.indexWhere(
            (item) => item.product.id == productId,
      );

      if (index != -1 && cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      }
    });
  }

  // Remove individual product
  void removeFromCart(int productId) {
    setState(() {
      cartItems.removeWhere(
            (item) => item.product.id == productId,
      );
    });
  }

  // Clear entire cart
  void clearCart() {
    setState(() {
      cartItems.clear();
    });
  }

  // Calculate total number of items
  int get totalItems {
    return cartItems.fold(
      0,
          (sum, item) => sum + item.quantity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping App'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      cartItems: cartItems,
                      onIncrease: increaseQuantity,
                      onDecrease: decreaseQuantity,
                      onRemove: removeFromCart,
                      onClear: clearCart,
                    ),
                  ),
                );
              },
              icon: Badge(
                label: Text('$totalItems'),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ],
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: products.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) {
            final product = products[index];


            return ProductCard(
              product: product,

              onAddToCart: () {
                addToCart(product);
              },

              onDetails: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      product: product,
                      onAddToCart: () {
                        addToCart(product);
                      },
                      totalItems: totalItems,
                      onCartTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartScreen(
                              cartItems: cartItems,
                              onIncrease: increaseQuantity,
                              onDecrease: decreaseQuantity,
                              onRemove: removeFromCart,
                              onClear: clearCart,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );

          },
        ),
      ),
    );
  }
}
