class StockData {
  // Yahan dukaan ka sara samaan save hoga
  static List<Map<String, dynamic>> products = [
    {'name': 'Aalu (Potato)', 'qty': 50, 'price': 20, 'unit': 'kg'},
    {'name': 'Pyaz (Onion)', 'qty': 30, 'price': 25, 'unit': 'kg'},
    {'name': 'Chawal (Rice)', 'qty': 100, 'price': 60, 'unit': 'kg'},
    {'name': 'Tel (Oil)', 'qty': 10, 'price': 150, 'unit': 'Ltr'},
    {'name': 'Namak (Salt)', 'qty': 5, 'price': 20, 'unit': 'Pkt'},
  ];

  // Naya item add karne ka function
  static void addProduct(Map<String, dynamic> product) {
    products.add(product);
  }
}