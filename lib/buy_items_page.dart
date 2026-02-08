import 'package:flutter/material.dart';

class BuyItemsPage extends StatelessWidget {
  const BuyItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Nakli Traders ka maal (Shopkeeper ko ye dikhega)
    final List<Map<String, dynamic>> marketItems = [
      {'item': 'Fortune Oil (15L Tin)', 'price': 1800, 'trader': 'Gupta Traders'},
      {'item': 'Basmati Rice (25kg)', 'price': 2200, 'trader': 'Punjab Rice Mill'},
      {'item': 'Sugar (50kg Sack)', 'price': 1950, 'trader': 'Maha Lakshmi Store'},
      {'item': 'Colgate (144 pcs Box)', 'price': 5600, 'trader': 'City Distributors'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Marketplace (Buy Stock)"), backgroundColor: Colors.purple, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: marketItems.length,
        itemBuilder: (context, index) {
          final deal = marketItems[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.shopping_bag, color: Colors.purple),
              ),
              title: Text(deal['item'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Sold by: ${deal['trader']}"), // Yahan Trader ka naam dikhega
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("₹${deal['price']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                  const Text("Tap to Order", style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order sent to ${deal['trader']}!")));
              },
            ),
          );
        },
      ),
    );
  }
}