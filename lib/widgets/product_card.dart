import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/preference_type.dart';
import 'preference_button.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.preference,
    required this.onLike,
    required this.onDislike,
    required this.onOpen,
  });

  final Product product;
  final PreferenceType? preference;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                          child: child,
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Text(
                        '\$${product.price.toStringAsFixed(2)} • ${product.category}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              product.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                PreferenceButton(
                  icon: Icons.thumb_up_alt_outlined,
                  label: 'Like',
                  selected: preference == PreferenceType.liked,
                  selectedColor: Colors.green,
                  onTap: onLike,
                ),
                const SizedBox(width: 8),
                PreferenceButton(
                  icon: Icons.thumb_down_alt_outlined,
                  label: 'Dislike',
                  selected: preference == PreferenceType.disliked,
                  selectedColor: Colors.red,
                  onTap: onDislike,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onOpen,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
