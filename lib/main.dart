import 'package:flutter/material.dart';
import 'login_page.dart'; // Login Page
import 'signup_page.dart'; // Signup Page
import 'ml_service.dart'; // 🧠 AI & ML Service (Dimag)

void main() async {
  // 1. Flutter Engine ko taiyaar karo
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. 🤖 AI Model (Kaggle Logic) Load karo
  // Ye line sabse zaroori hai, taaki app khulte hi smart ho jaye
  await MLService.loadModel();

  // 3. App Start karo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug ka ribbon hataya
      title: 'Smart Vyapar',
      theme: ThemeData(
        // Google Blue Theme Color
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A73E8)),
        useMaterial3: true,
      ),
      // App khulte hi Welcome Screen dikhegi
      home: const WelcomeScreen(), 
    );
  }
}

// --- WELCOME SCREEN (Sundaar Entry Gate) ---
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Icon
              const Icon(Icons.storefront_rounded, size: 100, color: Color(0xFF1A73E8)),
              const SizedBox(height: 20),
              
              // App Name
              const Text(
                "Smart Vyapar", 
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87)
              ),
              const SizedBox(height: 10),
              const Text(
                "Aapka Digital Vyapar Saathi 🤖",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              
              const SizedBox(height: 60),

              // Get Started Button (Signup Page ke liye)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const SignupPage())
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Get Started", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),

              // Sign In Button (Login Page ke liye)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const LoginPage())
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A73E8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}