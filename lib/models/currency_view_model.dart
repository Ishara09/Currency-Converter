import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:currency_converter/controller/currency_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyViewModel extends ChangeNotifier {
  final CurrencyService _currencyService = CurrencyService();
  Map<String, double> exchangeRates = {};
  List<String> preferredCurrencies = [];
  bool isLoading = false;
  String? error;
  Timer? _timer;
  String? baseCurrency;
  String? enteredAmount;

  CurrencyViewModel() {
    loadPreferredCurrencies();
    loadExchangeRates();
    _startPeriodicUpdate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> loadPreferredCurrencies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      preferredCurrencies = prefs.getStringList('preferredCurrencies') ?? [];
      baseCurrency = prefs.getString('baseCurrency') ?? 'USD';
      enteredAmount = prefs.getString('enteredAmount') ?? '';
      notifyListeners();
    } catch (e) {
      error = 'Failed to load preferred currencies: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> getExchangeRates(String baseCurrency) async {
    setLoading(true);
    try {
      exchangeRates = await _currencyService.fetchExchangeRates(baseCurrency);
      this.baseCurrency = baseCurrency;
      error = null;
      await _saveExchangeRates();
    } catch (e) {
      error = 'Failed to fetch exchange rates: ${e.toString()}';
    }
    setLoading(false);
  }

  Future<void> addPreferredCurrency(String currencyCode) async {
    if (!preferredCurrencies.contains(currencyCode)) {
      preferredCurrencies.add(currencyCode);
      await savePreferredCurrencies();
      notifyListeners();
    }
  }

  Future<void> removePreferredCurrency(String currencyCode) async {
    preferredCurrencies.remove(currencyCode);
    await savePreferredCurrencies();
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> savePreferredCurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('preferredCurrencies', preferredCurrencies);
    await prefs.setString('baseCurrency', baseCurrency ?? 'USD');
    await prefs.setString('enteredAmount', enteredAmount ?? '');
    debugPrint('Saved preferred currencies: $preferredCurrencies');
    debugPrint('Saved base currency: $baseCurrency');
    debugPrint('Saved entered amount: $enteredAmount');
  }

  Future<void> _saveExchangeRates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exchangeRates', jsonEncode(exchangeRates));
    debugPrint('Saved exchange rates: $exchangeRates');
  }

  Future<void> loadExchangeRates() async {
    final prefs = await SharedPreferences.getInstance();
    String? exchangeRatesString = prefs.getString('exchangeRates');
    if (exchangeRatesString != null) {
      exchangeRates = Map<String, double>.from(jsonDecode(exchangeRatesString));
      debugPrint('Loaded exchange rates: $exchangeRates');
      notifyListeners();
    }
  }

  void _startPeriodicUpdate() {
    _timer = Timer.periodic(Duration(minutes: 30), (timer) async {
      if (preferredCurrencies.isNotEmpty) {
        await getExchangeRates(preferredCurrencies.first);
      }
    });
  }
}
