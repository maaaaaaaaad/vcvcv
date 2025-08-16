import 'package:flutter/material.dart';
import 'shop/shop_detail_page.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/shopDetail':
      final id = settings.arguments as String?;
      if (id == null) return _error('잘못된 파라미터');
      return MaterialPageRoute(builder: (_) => ShopDetailPage(shopId: id));
    default:
      return null;
  }
}

Route<dynamic> _error(String message) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('오류')),
      body: Center(child: Text(message)),
    ),
  );
}
