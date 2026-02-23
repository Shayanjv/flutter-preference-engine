import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../viewmodels/browser_history_viewmodel.dart';

class ProductWebViewPage extends StatefulWidget {
  const ProductWebViewPage({
    super.key,
    required this.initialUrl,
    required this.title,
  });

  final String initialUrl;
  final String title;

  @override
  State<ProductWebViewPage> createState() => _ProductWebViewPageState();
}

class _ProductWebViewPageState extends State<ProductWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            context.read<BrowserHistoryViewModel>().trackUrl(url);
          },
          onWebResourceError: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title, maxLines: 1)),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.white70),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
