import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_converter/models/currency_view_model.dart';
import 'package:currency_converter/screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrencyViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advance Exchanger',
      home: HomeScreen(),
    );
  }
}
