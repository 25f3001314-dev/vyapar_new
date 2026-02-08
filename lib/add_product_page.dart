import 'package:flutter/material.dart';
import 'stock_data.dart'; // Database connection
import 'ml_service.dart'; // 🧠 AI Brain connection

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  // Controllers (Input lene ke liye)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  
  // Default Unit
  String selectedUnit = 'kg'; 

  // --- 1. SAVE FUNCTION (Purana Logic + Crash Proof) ---
  void _saveProduct() {
    // Validation: Khali form na save ho
    if (nameController.text.isEmpty || qtyController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kripya saari details bharein! 📝"), backgroundColor: Colors.red)
      );
      return;
    }

    // Data banayein
    Map<String, dynamic> newProduct = {
      'name': nameController.text.trim(),
      'qty': int.tryParse(qtyController.text) ?? 0, // tryParse crash hone se bachata hai
      'price': double.tryParse(priceController.text) ?? 0.0,
      'unit': selectedUnit,
    };

    // StockData mein save karein
    StockData.addProduct(newProduct);

    // Success Message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Item Add Ho Gaya! ✅"), backgroundColor: Colors.green)
    );
    Navigator.pop(context); // Wapas jao
  }

  // --- 2. AI DEMAND CHECK (Naya Advanced Feature) ---
  void _checkSmartDemand() {
    String brand = nameController.text.trim();
    if (brand.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pehle Product ka naam likhein!"))
      );
      return;
    }

    // 🧠 AI se poocho (MLService call)
    var result = MLService.predictDemand(brand, "General");

    // Result dikhao (Sundar Popup)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.auto_graph, color: Colors.purple),
            SizedBox(width: 10),
            Text("Market Analysis"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Product: $brand", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Demand: ", style: TextStyle(fontSize: 16)),
                Text(
                  result['label'], 
                  style: TextStyle(
                    color: Color(result['color']), 
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                  )
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text("Success Score: ${result['score']}%", style: const TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Stock"), 
        backgroundColor: const Color(0xFF1A73E8), // Google Blue
        foregroundColor: Colors.white
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Icon
            const Icon(Icons.inventory_2_outlined, size: 60, color: Color(0xFF1A73E8)),
            const SizedBox(height: 20),

            // Name Field
            TextField(
              controller: nameController, 
              decoration: const InputDecoration(
                labelText: "Product / Brand Name", 
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_bag_outlined)
              )
            ),
            const SizedBox(height: 15),

            // Price Field
            TextField(
              controller: priceController, 
              keyboardType: TextInputType.number, 
              decoration: const InputDecoration(
                labelText: "Price (₹)", 
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee)
              )
            ),
            const SizedBox(height: 15),

            // Qty & Unit Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: qtyController, 
                    keyboardType: TextInputType.number, 
                    decoration: const InputDecoration(
                      labelText: "Quantity", 
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers)
                    )
                  )
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedUnit,
                      items: ['kg', 'Ltr', 'Pkt', 'Pc', 'Gm'].map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (newValue) => setState(() => selectedUnit = newValue!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // --- AI BUTTON (Purple) ---
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _checkSmartDemand,
                icon: const Icon(Icons.analytics, color: Colors.purple),
                label: const Text("Check Demand (AI Prediction)", style: TextStyle(color: Colors.purple, fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(15), 
                  side: const BorderSide(color: Colors.purple)
                ),
              ),
            ),
            const SizedBox(height: 15),

            // --- SAVE BUTTON (Blue) ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.save),
                label: const Text("Save to Stock", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8), 
                  foregroundColor: Colors.white, 
                  padding: const EdgeInsets.all(16)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}