import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/preference_type.dart';
import '../utils/url_utils.dart';
import '../viewmodels/preference_viewmodel.dart';
import '../viewmodels/product_feed_viewmodel.dart';
import '../widgets/product_card.dart';
import 'history_view.dart';
import 'product_webview_page.dart';

class ProductFeedView extends StatelessWidget {
  const ProductFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Feed'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, HistoryView.routeName),
            icon: const Icon(Icons.history),
            tooltip: 'History',
          ),
        ],
      ),
      body: Consumer2<ProductFeedViewModel, PreferenceViewModel>(
        builder: (context, feedVm, prefVm, _) {
          return RefreshIndicator(
            onRefresh: () => feedVm.load(forceRefresh: true),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                    child: TextField(
                      onChanged: feedVm.setSearchQuery,
                      decoration: const InputDecoration(
                        labelText: 'Search products',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonFormField<String>(
                      value: feedVm.selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: feedVm.categories
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          feedVm.setCategory(value);
                        }
                      },
                    ),
                  ),
                ),
                if (feedVm.isLoading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (feedVm.errorMessage != null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text(feedVm.errorMessage!)),
                  )
                else if (feedVm.products.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text('No products match your filters yet.'),
                    ),
                  )
                else
                  SliverList.builder(
                    itemCount: feedVm.products.length,
                    itemBuilder: (context, index) {
                      final product = feedVm.products[index];
                      return ProductCard(
                        product: product,
                        preference: prefVm.preferenceFor(product.id),
                        onLike: () =>
                            prefVm.togglePreference(product.id, PreferenceType.liked),
                        onDislike: () => prefVm.togglePreference(
                          product.id,
                          PreferenceType.disliked,
                        ),
                        onOpen: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => ProductWebViewPage(
                              initialUrl: buildProductUrl(product.id),
                              title: product.title,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
