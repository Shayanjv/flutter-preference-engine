import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/product_repository.dart';
import 'services/product_service.dart';
import 'viewmodels/browser_history_viewmodel.dart';
import 'viewmodels/preference_viewmodel.dart';
import 'viewmodels/product_feed_viewmodel.dart';
import 'views/history_view.dart';
import 'views/product_feed_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final productRepository = ProductRepository(ProductService());
  final preferenceViewModel = PreferenceViewModel();
  final historyViewModel = BrowserHistoryViewModel();

  await Future.wait<void>([
    preferenceViewModel.initialize(),
    historyViewModel.initialize(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider<ProductRepository>.value(value: productRepository),
        ChangeNotifierProvider<PreferenceViewModel>.value(
          value: preferenceViewModel,
        ),
        ChangeNotifierProvider<BrowserHistoryViewModel>.value(
          value: historyViewModel,
        ),
        ChangeNotifierProvider<ProductFeedViewModel>(
          create: (context) =>
              ProductFeedViewModel(context.read<ProductRepository>())..load(),
        ),
      ],
      child: const PreferenceEngineApp(),
    ),
  );
}

class PreferenceEngineApp extends StatelessWidget {
  const PreferenceEngineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Preference Engine',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routes: {
        '/': (_) => const ProductFeedView(),
        HistoryView.routeName: (_) => const HistoryView(),
      },
    );
  }
}
