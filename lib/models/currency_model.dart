class Currency {
  final String code;
  final String name;
  final String imagePath;

  Currency(this.code, this.name, this.imagePath);

  static List<Currency> getCurrencies() {
    return [
      Currency('USD', 'United States Dollar', 'assets/us.gif'),
      Currency('EUR', 'Euro', 'assets/euro.jfif'),
      Currency('GBP', 'British Pound', 'assets/uk.gif'),
      Currency('AUD', 'Australian Dollar', 'assets/aus.gif'),
      Currency('CAD', 'Canadian Dollar', 'assets/canada.gif'),
      Currency('JPY', 'Japanese Yen', 'assets/japan.gif'),
      Currency('CNY', 'Chinese Yuan', 'assets/china.gif'),
      Currency('INR', 'Indian Rupee', 'assets/india.gif'),
      Currency('CHF', 'Swiss Franc', 'assets/switzerland.gif'),
      Currency('NZD', 'New Zealand Dollar', 'assets/newzealand.gif'),
      Currency('MXN', 'Mexican Peso', 'assets/mexico.gif'),
      Currency('RUB', 'Russian Ruble', 'assets/russia.gif'),
      Currency('BRL', 'Brazilian Real', 'assets/brazil.gif'),
      Currency('ZAR', 'South African Rand', 'assets/southafrica.gif'),
    ];
  }
}
