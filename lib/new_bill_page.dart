import 'package:flutter/material.dart';
import 'voice_service.dart';
import 'ocr_service.dart';
import 'bill_data.dart'; // ⚠️ YE LINE ZAROORI HAI: Tabhi bill save hoga

class NewBillPage extends StatefulWidget {
  final String userRole;
  const NewBillPage({super.key, required this.userRole});

  @override
  State<NewBillPage> createState() => _NewBillPageState();
}

class _NewBillPageState extends State<NewBillPage> {
  // 🛒 Bill Items List
  List<Map<String, dynamic>> cartItems = [];

  // 📝 Text Controllers
  final TextEditingController partyNameController = TextEditingController();
  final TextEditingController itemController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  bool _isListening = false;
  bool _isLoading = false; // Loading dikhane ke liye

  // 🧹 Memory Safai
  @override
  void dispose() {
    partyNameController.dispose();
    itemController.dispose();
    priceController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  // 💰 Total Calculation
  double get totalAmount {
    double total = 0;
    for (var item in cartItems) {
      total += item['total'];
    }
    return total;
  }

  // ➕ Item Add Logic
  void _addItem() {
    if (itemController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Item and Price"))
      );
      return;
    }

    String name = itemController.text;
    double price = double.tryParse(priceController.text) ?? 0;
    int qty = int.tryParse(qtyController.text) ?? 1;
    double lineTotal = price * qty;

    setState(() {
      cartItems.add({'name': name, 'price': price, 'qty': qty, 'total': lineTotal});
      // Fields clear karein
      itemController.clear();
      priceController.clear();
      qtyController.text = "1";
    });
  }

  // 🧠 Data Processing Function (Gemini Result se Form bharna)
  void _fillFormWithGeminiData(Map<String, String> result) {
    if (result['item'] != null && result['item']!.isNotEmpty) {
      itemController.text = result['item']!;
    }
    if (result['price'] != null && result['price'] != "0") {
      priceController.text = result['price']!;
    }
    if (result['qty'] != null) {
      qtyController.text = result['qty']!;
    }
  }

  @override
  void initState() {
    super.initState();
    qtyController.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    bool isTrader = widget.userRole == "Trader";
    bool isShopkeeper = widget.userRole == "Shopkeeper";

    return Scaffold(
      appBar: AppBar(
        title: Text(isTrader ? "Trader Invoice" : "Shopkeeper Assistant"),
        backgroundColor: isTrader ? const Color(0xFFE85D1A) : const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
        actions: [
          
          // 📷 TRADER CAMERA BUTTON (Smart Scan)
          if (isTrader)
            IconButton(
              icon: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : const Icon(Icons.camera_alt),
              tooltip: "Scan Bill",
              onPressed: _isLoading ? null : () async {
                
                // 1. OCR: Text Nikalo
                String scannedText = await OCRService.scanBill();
                
                if (scannedText.startsWith("Error") || scannedText == "Bill khali tha" || scannedText == "No image selected") {
                   if(mounted && !scannedText.contains("No image")) {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(scannedText)));
                   }
                   return;
                }

                if (mounted) {
                  setState(() => _isLoading = true); // Loading shuru
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Bill padh liya! Ab data nikal raha hoon... 🤖"))
                  );
                }

                // 2. Gemini: Text ko samjho
                var result = await VoiceService.samajhBhai(scannedText);

                // 3. Form: Data bharo
                if (mounted) {
                   setState(() {
                     _isLoading = false; // Loading khatam
                     
                     // Agar Gemini ko Item nahi mila, toh pura text Name mein daal do (Backup)
                     if (result['item'] == null || result['item']!.isEmpty) {
                       partyNameController.text = scannedText;
                     } else {
                       _fillFormWithGeminiData(result);
                     }
                   });
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Section 1: Name Input
          Container(
            padding: const EdgeInsets.all(16.0),
            color: isTrader ? Colors.orange.shade50 : Colors.blue.shade50,
            child: TextField(
              controller: partyNameController,
              decoration: InputDecoration(
                labelText: isTrader ? "Shop/Dealer Name (Or Scan Result)" : "Customer Name",
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.person)
              )
            ),
          ),

          // Section 2: Manual Add Inputs
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(flex: 2, child: TextField(controller: itemController, decoration: const InputDecoration(labelText: "Item"))),
                const SizedBox(width: 8),
                Expanded(flex: 1, child: TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Price"))),
                const SizedBox(width: 8),
                Expanded(flex: 1, child: TextField(controller: qtyController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Qty"))),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addItem, child: const Icon(Icons.add)),
              ],
            ),
          ),

          // Section 3: List of Added Items
          Expanded(
            child: cartItems.isEmpty 
              ? Center(child: Text("No items added yet", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.shopping_cart, size: 20)),
                      title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Qty: ${item['qty']} x ₹${item['price']}"),
                      trailing: Text("₹${item['total']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                    );
                  },
                ),
          ),

          // Section 4: Voice Mic (SHOPKEEPER MIC 🎤)
          if (isShopkeeper)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FloatingActionButton.large(
                onPressed: () {
                  if (!_isListening) {
                    // Start Listening
                    VoiceService.listen((text) async {
                      
                      // User feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sun liya: '$text'. Soch raha hoon... 🤔"), duration: const Duration(seconds: 1))
                      );

                      // Gemini Call
                      var result = await VoiceService.samajhBhai(text);

                      // Fill Form
                      if (mounted) {
                        setState(() => _fillFormWithGeminiData(result));
                      }
                    }, (listening) => setState(() => _isListening = listening));
                  } else {
                    // Stop Listening
                    VoiceService.stop();
                    setState(() => _isListening = false);
                  }
                },
                backgroundColor: _isListening ? Colors.red : Colors.blue,
                child: Icon(_isListening ? Icons.stop : Icons.mic),
              ),
            ),

          // Section 5: Total & Save
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, -3))]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: ₹$totalAmount", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                
                // SAVE BUTTON (Ab BillData.addBill karega)
                ElevatedButton.icon(
                  onPressed: () {
                    if (cartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Bill khali hai! Kuch items add karein."))
                      );
                      return;
                    }

                    // 1. Bill ka data taiyaar karein
                    Map<String, dynamic> newBill = {
                      'partyName': partyNameController.text.isEmpty ? "Unknown" : partyNameController.text,
                      'date': DateTime.now().toString().split(' ')[0], // Aaj ki taareekh
                      'total': totalAmount,
                      'items': List.from(cartItems), // Items ki copy
                    };

                    // 2. BillData mein save karein
                    BillData.addBill(newBill);

                    // 3. User ko batayein aur wapas jayein
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Bill Save Ho Gaya! ✅"))
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Save Bill"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isTrader ? Colors.orange : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}