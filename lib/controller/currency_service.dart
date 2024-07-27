import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyService {
  final String _apiUrl = 'https://api.exchangerate-api.com/v4/latest';

  Future<Map<String, double>> fetchExchangeRates(String baseCurrency) async {
    final response = await http.get(Uri.parse('$_apiUrl/$baseCurrency'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['rates'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value.toDouble()));
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}
