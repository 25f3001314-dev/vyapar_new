import 'package:flutter/material.dart';
import 'bill_data.dart'; // ⚠️ YE IMPORT ZAROORI HAI

class SaleHistoryPage extends StatefulWidget {
  const SaleHistoryPage({super.key});

  @override
  State<SaleHistoryPage> createState() => _SaleHistoryPageState();
}

class _SaleHistoryPageState extends State<SaleHistoryPage> {
  @override
  Widget build(BuildContext context) {
    // 1. Asli Data mangwayein (BillData file se)
    final List<Map<String, dynamic>> bills = BillData.getBills();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sale History"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: bills.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Abhi koi bill nahi bana 📉", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: bills.length,
              itemBuilder: (context, index) {
                final bill = bills[index];
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.receipt_long, color: Colors.white),
                    ),
                    // 2. Sahi keys use karein (partyName, date, total)
                    title: Text(
                      bill['partyName'] ?? "Unknown", 
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text(bill['date'] ?? ""),
                    trailing: Text(
                      "₹${bill['total']}", 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)
                    ),
                  ),
                );
              },
            ),
    );
  }
}