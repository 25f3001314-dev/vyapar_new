import 'package:flutter/material.dart';
import 'user_data.dart'; // Database connection
import 'login_page.dart'; // Link to Login Page

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Text Controllers to capture input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController(); 
  final TextEditingController passController = TextEditingController(); 
  final TextEditingController gstController = TextEditingController(); // ✅ GST Controller added
  
  String selectedRole = 'Shopkeeper'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Create Account"), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 60, color: Color(0xFF1A73E8)),
            const SizedBox(height: 20),
            
            // --- 1. FULL NAME ---
            _buildTextField("Full Name", Icons.person, nameController),
            const SizedBox(height: 15),

            // --- 2. MOBILE NUMBER ---
            _buildTextField("Mobile Number", Icons.phone, phoneController, isNumber: true),
            const SizedBox(height: 15),

            // --- 3. EMAIL ADDRESS ---
            _buildTextField("Email Address", Icons.email, emailController),
            const SizedBox(height: 15),
            
            // --- 4. PASSWORD ---
            TextField(
              controller: passController,
              obscureText: true, // Hide password
              decoration: InputDecoration(
                labelText: "Create Password",
                prefixIcon: const Icon(Icons.lock, color: Color(0xFF1A73E8)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            
            // --- 5. GST NUMBER (Optional) ---
            _buildTextField("GST Number (Optional)", Icons.business, gstController),
            const SizedBox(height: 20),

            // --- ROLE SELECTION (Radio Buttons) ---
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: const Text("Shopkeeper", style: TextStyle(fontSize: 14)), 
                      value: "Shopkeeper", 
                      groupValue: selectedRole, 
                      activeColor: const Color(0xFF1A73E8),
                      onChanged: (v) => setState(() => selectedRole = v!)
                    )
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: const Text("Trader", style: TextStyle(fontSize: 14)), 
                      value: "Trader", 
                      groupValue: selectedRole, 
                      activeColor: const Color(0xFFE85D1A),
                      onChanged: (v) => setState(() => selectedRole = v!)
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- REGISTER BUTTON ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Register", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            
            // --- LOGIN LINK ---
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text("Already have an account? Login"),
            )
          ],
        ),
      ),
    );
  }

  void _registerUser() {
    // 1. Validation: Ensure required fields are filled (GST is optional)
    if (nameController.text.isEmpty || phoneController.text.isEmpty || emailController.text.isEmpty || passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Naam, Phone, Email aur Password zaroori hai!")
        )
      );
      return;
    }

    // 2. Save Data to Database
    // ✅ Sending 'gstController.text' correctly now
    UserData.addUser(
      nameController.text.trim(), 
      phoneController.text.trim(),
      emailController.text.trim(), 
      passController.text.trim(), 
      selectedRole,
      gstController.text.trim() // <-- GST Data is passed here
    );

    // 3. Success Message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green, 
        content: Text("Account Ban Gaya! ✅ Ab Login karein.")
      )
    );
    
    // Redirect to Login Page
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  // Helper widget for cleaner code
  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1A73E8)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}