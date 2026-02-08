import 'package:flutter/material.dart';
import 'user_data.dart'; // Database connect kiya
import 'home_page.dart'; // Dashboard connect kiya
import 'signup_page.dart'; // Signup page link

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Input lene ke liye controllers
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // --- LOGIN CHECK KARNE KA ASLI LOGIC ---
  void _login() {
    String phone = phoneController.text.trim();
    String password = passController.text.trim();

    // 1. Database mein check karo user hai ya nahi (Updated Function use kiya)
    // Ye function ab pura User Map wapas karega (Name aur Role ke saath)
    var user = UserData.checkLogin(phone, password);

    if (user != null) {
      // 2. Agar user mil gaya -> TOH ROLE AUR NAME NIKALO
      String role = user['role'] ?? "Shopkeeper"; 
      String name = user['name'] ?? "User";

      // User ko Welcome Message dikhao
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Welcome $name ($role) 👋"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        )
      );

      // 3. Sahi Dashboard par bhejo (Role aur Name ke saath)
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => HomePage(userRole: role, userName: name)
        )
      );
      
      print("Login Success: $name as $role"); // Terminal mein dikhega
    } else {
      // 4. Agar galat hai -> Error dikhao
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red, 
          content: Text("Galat Mobile Number ya Password! ❌"),
          duration: Duration(seconds: 2),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Login"), backgroundColor: const Color(0xFF1A73E8), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_person, size: 80, color: Color(0xFF1A73E8)),
            const SizedBox(height: 20),
            
            // Mobile Field
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Mobile Number", 
                prefixIcon: const Icon(Icons.phone), 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
              ),
            ),
            const SizedBox(height: 20),

            // Password Field
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password", 
                prefixIcon: const Icon(Icons.lock), 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
              ),
            ),
            const SizedBox(height: 30),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login, // Button dabane par upar wala function chalega
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Login Securely", style: TextStyle(fontSize: 18)),
              ),
            ),

            // Signup Link
            TextButton(
              onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
              },
              child: const Text("New here? Create Account"),
            )
          ],
        ),
      ),
    );
  }
}