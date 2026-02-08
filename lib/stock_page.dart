import 'package:flutter/material.dart';
import 'stock_data.dart'; // Data yahan se aayega
import 'add_product_page.dart'; // ✅ Ye line zaroori hai naya page kholne ke liye

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  // Data refresh karne ke liye
  void _refreshStock() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // StockData file se list mangwayein
    var stockList = StockData.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Stock / Inventory"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _refreshStock, icon: const Icon(Icons.refresh))
        ],
      ),
      backgroundColor: Colors.grey[100], // Thoda light background
      
      body: stockList.isEmpty
          ? const Center(child: Text("Stock khali hai! 📦", style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: stockList.length,
              itemBuilder: (context, index) {
                var item = stockList[index];
                
                // Check: Kya stock kam hai? (10 se kam hone par Red)
                bool isLowStock = item['qty'] < 10;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isLowStock ? Colors.red[100] : Colors.green[100],
                      child: Icon(
                        Icons.inventory_2, 
                        color: isLowStock ? Colors.red : Colors.green
                      ),
                    ),
                    title: Text(
                      item['name'], 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    subtitle: Text(
                      "Price: ₹${item['price']}/${item['unit']}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isLowStock ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${item['qty']} ${item['unit']}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
      
      // ✅ NAYA BUTTON: Jo Ab Asli Page Kholega
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add Product Page khulega
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AddProductPage())
          ).then((_) => _refreshStock()); // Wapas aane par list refresh karega
        },
        backgroundColor: Colors.green[700],
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Item", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}