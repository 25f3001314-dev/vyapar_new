import 'package:flutter/material.dart';
// Saare Pages ko Import kiya
import 'new_bill_page.dart';
import 'stock_page.dart';
import 'buy_items_page.dart';
import 'sale_history_page.dart';
import 'add_product_page.dart';
import 'orders_page.dart';
import 'login_page.dart'; // Login page import kiya logout ke liye

class HomePage extends StatelessWidget {
  final String userRole; // Role (Shopkeeper/Trader)
  final String userName; // 👈 ERROR FIX: Naam bhi add kar diya

  // Constructor mein 'userName' joda taaki Login page error na de
  const HomePage({
    super.key, 
    required this.userRole, 
    required this.userName
  });

  @override
  Widget build(BuildContext context) {
    // Check karein: Kya ye Shopkeeper hai?
    bool isShopkeeper = userRole == "Shopkeeper";

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        // Shopkeeper ke liye Blue, Trader ke liye Orange
        backgroundColor: isShopkeeper ? const Color(0xFF1A73E8) : const Color(0xFFE85D1A), 
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dukan ka naam aur User ka naam dikhayenge
            Text(
              isShopkeeper ? "My Dukan" : "Trader Market", 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
            Text(
              "Welcome, $userName 👋", // 👋 Yahan naam dikhega
              style: const TextStyle(color: Colors.white70, fontSize: 12)
            ),
          ],
        ),
        actions: [
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const LoginPage())
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- SUMMARY CARD (Dono ke liye alag data) ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isShopkeeper ? Colors.blue.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isShopkeeper ? Colors.blue : Colors.orange),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isShopkeeper ? "Today's Sale" : "Total Orders", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                      Text(isShopkeeper ? "₹ 12,500" : "58 Orders", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(isShopkeeper ? Icons.point_of_sale : Icons.local_shipping, size: 40, color: isShopkeeper ? Colors.blue : Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- MENU GRID (Logic wapas aa gaya!) ---
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: isShopkeeper 
              ? [ // SHOPKEEPER KE BUTTONS (Blue)
                  _buildMenuCard(context, Icons.add_shopping_cart, "New Bill", Colors.blue),
                  _buildMenuCard(context, Icons.inventory, "My Stock", Colors.green),
                  _buildMenuCard(context, Icons.people, "Buy Items", Colors.purple),
                  _buildMenuCard(context, Icons.history, "Sale History", Colors.indigo),
                ]
              : [ // TRADER KE BUTTONS (Orange)
                  _buildMenuCard(context, Icons.store, "My Dealers", Colors.orange),
                  _buildMenuCard(context, Icons.add_box, "Add Product", Colors.deepOrange),
                  _buildMenuCard(context, Icons.list_alt, "Orders Received", Colors.red),
                  _buildMenuCard(context, Icons.trending_up, "Market Trends", Colors.teal),
                ],
            ),
          ],
        ),
      ),
    );
  }

  // --- MENU CARD BUILDER ---
  Widget _buildMenuCard(BuildContext context, IconData icon, String title, Color color) {
    return GestureDetector(
      onTap: () {
        // --- BUTTONS KA LOGIC ---
        
        // 1. Common
        if (title == "New Bill") {
           // Agar NewBillPage role maangta hai toh pass karein
           Navigator.push(context, MaterialPageRoute(builder: (context) => NewBillPage(userRole: userRole)));
        } 
        
        // 2. Shopkeeper Features
        else if (title == "My Stock") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const StockPage()));
        }
        else if (title == "Buy Items") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BuyItemsPage()));
        }
        else if (title == "Sale History") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SaleHistoryPage()));
        }
        
        // 3. Trader Features
        else if (title == "Add Product") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductPage()));
        }
        else if (title == "Orders Received") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
        }
        
        // 4. Coming Soon
        else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CommonPage(title: title)));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, spreadRadius: 2)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// --- Placeholder Page ---
class CommonPage extends StatelessWidget {
  final String title;
  const CommonPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text("$title Feature Coming Soon!", style: const TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}