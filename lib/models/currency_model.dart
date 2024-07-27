class Currency {
  final String code;
  final String name;
  final String imagePath;

  Currency(this.code, this.name, this.imagePath);

  static List<Currency> getCurrencies() {
    return [
      Currency('USD', 'United States Dollar', 'assets/us.gif'),
      Currency('EUR', 'Euro', 'assets/us.gif'),
      Currency('GBP', 'British Pound', 'assets/uk.gif'),
      Currency('AUD', 'Australian Dollar', 'assets/aus.gif'),
    ];
  }
}
