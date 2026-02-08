import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Trader ko ye Orders dikhenge (Anek dukandaaron se)
    final List<Map<String, dynamic>> orders = [
      {'shop': 'Sharma Kirana', 'item': '50kg Sugar', 'status': 'Pending', 'mobile': '9876543210'},
      {'shop': 'Apna Bazaar', 'item': '10 Cartons Oil', 'status': 'Confirmed', 'mobile': '9988776655'},
      {'shop': 'Rohan General Store', 'item': '20 Boxes Biscuits', 'status': 'Pending', 'mobile': '9123456789'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Orders Received"), backgroundColor: Colors.red, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: order['status'] == 'Pending' ? Colors.orange.shade100 : Colors.green.shade100,
                child: Icon(order['status'] == 'Pending' ? Icons.hourglass_top : Icons.check, color: Colors.black54),
              ),
              title: Text(order['shop'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Ordered: ${order['item']}\nMob: ${order['mobile']}"),
              isThreeLine: true,
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: order['status'] == 'Pending' ? Colors.green : Colors.grey,
                  foregroundColor: Colors.white
                ),
                child: Text(order['status'] == 'Pending' ? "Accept" : "Done"),
              ),
            ),
          );
        },
      ),
    );
  }
}