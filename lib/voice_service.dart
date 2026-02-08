import 'dart:convert'; // Required for JSON decoding to prevent crashes
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'stock_data.dart'; // Importing Inventory Data

class VoiceService {
  static final SpeechToText _speech = SpeechToText();
  
  // 🔑 API KEY (Keep this safe)
  static const String apiKey = 'AIzaSyBS7h1tIZZCpbE9O2ZlfGJ169vs14zX2Yg'; 

  // ---------------------------------------------------------------------------
  // 🎤 MICROPHONE LOGIC (Safe & Robust)
  // ---------------------------------------------------------------------------
  static Future<void> listen(Function(String) onResult, Function(bool) isListening) async {
    // Initialize speech engine with error handling
    // If permission is denied, 'available' will be false, preventing a crash.
    bool available = await _speech.initialize(
      onError: (val) {
        print("Mic Error: $val");
        isListening(false); // Stop UI animation on error
      },
      onStatus: (val) => isListening(val == 'listening'),
    );

    if (available) {
      isListening(true);
      _speech.listen(
        onResult: (result) => onResult(result.recognizedWords),
        listenFor: const Duration(seconds: 15), // Listen for up to 15 seconds
        pauseFor: const Duration(seconds: 3),   // Stop if silence for 3 seconds
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
    } else {
      print("Microphone permission denied or not available.");
      isListening(false);
    }
  }

  static void stop() {
    _speech.stop();
  }

  // ---------------------------------------------------------------------------
  // 🧠 GEMINI AI LOGIC (Smart & Crash-Proof)
  // ---------------------------------------------------------------------------
  static Future<Map<String, String>> samajhBhai(String command) async {
    // 1. Basic Check: If no audio, return empty
    if (command.isEmpty) return {};

    try {
      // Initialize Gemini Model (Flash model is faster for real-time use)
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      // 2. Prepare Context: Convert Stock Data to a String format
      // This allows Gemini to know the prices of items in your shop.
      String stockContext = StockData.products.map((e) => "${e['name']} (Price: ${e['price']})").join(", ");

      // 3. The "Super Prompt"
      // Instructions are in English for better AI compliance.
      final prompt = '''
        Role: Smart Billing Assistant.
        
        INVENTORY / STOCK LIST: [$stockContext]
        USER VOICE COMMAND: "$command"

        INSTRUCTIONS:
        1. Identify 'item': Match with inventory if possible.
        2. Identify 'qty' (quantity): If missing, default to 1.
        3. Identify 'price': 
           - Priority 1: Use the price explicitly mentioned by the user in the command (e.g., "50 rupaye wala").
           - Priority 2: If user didn't say price, look up the price in the INVENTORY list provided above.
           - Priority 3: If unknown, set to 0.

        OUTPUT FORMAT:
        Return ONLY valid JSON. No markdown codes. 
        Example: {"item": "Maggi", "price": "12", "qty": "2"}
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      String result = response.text ?? "{}";
      
      // 4. Data Sanitization (Cleaning)
      // Removes "```json" or "```" if Gemini adds them, to prevent parsing errors.
      result = result.replaceAll('```json', '').replaceAll('```', '').trim();
      
      // 5. Safe Parsing (The Crash Guard)
      Map<String, dynamic> parsedJson = jsonDecode(result);

      // 6. Type Safety Return
      // We use '.toString()' on every value. This ensures that even if Gemini 
      // sends a Number (Int) instead of Text (String), the App won't crash.
      return {
        "item": parsedJson['item']?.toString() ?? command, // Fallback to command if item is null
        "price": parsedJson['price']?.toString() ?? "0",
        "qty": parsedJson['qty']?.toString() ?? "1"
      };

    } catch (e) {
      print("Gemini Processing Error: $e");
      
      // 🚨 Fallback Mechanism
      // If internet fails, quota exceeds, or logic breaks, 
      // we return the raw text so the user can edit it manually.
      // This ensures the user never loses their input.
      return {
        "item": command, 
        "price": "0", 
        "qty": "1"
      };
    }
  }
}