import 'package:currency_converter/models/currency_view_model.dart';
import 'package:currency_converter/models/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _amountController = TextEditingController();
  String? selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<CurrencyViewModel>();
      viewModel.loadPreferredCurrencies().then((_) {
        setState(() {
          selectedCurrency = viewModel.baseCurrency;
          _amountController.text = viewModel.enteredAmount ?? '';
          context.read<CurrencyViewModel>().getExchangeRates(selectedCurrency!);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(70, 133, 133, 90),
        title: Text(
          'Advance Exchanger',
          style: GoogleFonts.poppins(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Insert Amount',
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildAmountAndCurrencyField(context),
            const SizedBox(height: 16.0),
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Convert TO',
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            _buildTargetCurrencyList(context),
            const SizedBox(height: 16.0),
            _buildAddConverterButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountAndCurrencyField(BuildContext context) {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color.fromRGBO(70, 133, 133, 90),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color.fromRGBO(70, 133, 133, 90),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color.fromRGBO(70, 133, 133, 90),
          ),
        ),
        labelText: 'Amount and Currency',
        prefixIcon: const Icon(Icons.money),
        suffixIcon: _buildCurrencyDropdown(context),
      ),
      onChanged: (value) {
        context.read<CurrencyViewModel>().enteredAmount = value;
        context.read<CurrencyViewModel>().savePreferredCurrencies();
      },
    );
  }

  Widget _buildCurrencyDropdown(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedCurrency,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
            if (value != null) {
              context.read<CurrencyViewModel>().getExchangeRates(value);
            }
          });
        },
        items: Currency.getCurrencies()
            .map((currency) => DropdownMenuItem<String>(
                  value: currency.code,
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          currency.imagePath,
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(currency.code),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTargetCurrencyList(BuildContext context) {
    return Expanded(
      child: Consumer<CurrencyViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          } else {
            return ListView.builder(
              itemCount: viewModel.preferredCurrencies.length,
              itemBuilder: (context, index) {
                String currency = viewModel.preferredCurrencies[index];
                double rate = viewModel.exchangeRates[currency] ?? 0.0;
                double amount = double.tryParse(_amountController.text) ?? 0.0;
                double convertedAmount = amount * rate;
                return _buildCurrencyTile(context, currency, convertedAmount);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCurrencyTile(
      BuildContext context, String currency, double convertedAmount) {
    Currency currencyDetails = Currency.getCurrencies().firstWhere(
      (c) => c.code == currency,
      orElse: () =>
          Currency('Unknown', 'Unknown Currency', 'assets/images/default.gif'),
    );

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(currencyDetails.imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          ' ${currencyDetails.code}: ${convertedAmount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18.0),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            context.read<CurrencyViewModel>().removePreferredCurrency(currency);
          },
        ),
      ),
    );
  }

  Widget _buildAddConverterButton(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: SizedBox(
        width: 200,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          onPressed: () {
            _showAddCurrencyDialog(context);
          },
          child: Text(
            '+ ADD CONVERTER',
            style: GoogleFonts.poppins(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showAddCurrencyDialog(BuildContext context) {
    String? selectedNewCurrency;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Target Currency'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Currency',
                  prefixIcon: Icon(Icons.account_balance_wallet),
                ),
                value: selectedNewCurrency,
                isExpanded: true,
                items: Currency.getCurrencies()
                    .map((currency) => DropdownMenuItem<String>(
                          value: currency.code,
                          child: Row(
                            children: [
                              Image.asset(
                                currency.imagePath,
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text(currency.code),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedNewCurrency = value;
                  });
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (selectedNewCurrency != null) {
                  context
                      .read<CurrencyViewModel>()
                      .addPreferredCurrency(selectedNewCurrency!);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
