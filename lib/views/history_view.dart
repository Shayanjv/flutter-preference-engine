import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/browser_history_viewmodel.dart';
import 'product_webview_page.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  static const String routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browsing History'),
        actions: [
          IconButton(
            onPressed: () => context.read<BrowserHistoryViewModel>().clearHistory(),
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear history',
          ),
        ],
      ),
      body: Consumer<BrowserHistoryViewModel>(
        builder: (context, vm, _) {
          if (vm.history.isEmpty) {
            return const Center(
              child: Text('No visited URLs yet. Open a product to begin tracking.'),
            );
          }

          return ListView.separated(
            itemCount: vm.history.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final url = vm.history[index];
              return ListTile(
                title: Text(
                  url,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: const Icon(Icons.link),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => ProductWebViewPage(
                      initialUrl: url,
                      title: 'Visited page',
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
