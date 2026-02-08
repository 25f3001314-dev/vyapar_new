import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCRService {
  // Singleton pattern: Ek baar machine on hogi, baar-baar nahi
  static final TextRecognizer _textRecognizer = TextRecognizer();
  static final ImagePicker _picker = ImagePicker();

  static Future<String> scanBill() async {
    try {
      // 1. Camera se photo khinchye
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Professional quality
      );

      if (image == null) return "No image selected";

      // 2. Google ML Kit ko photo bhejiye
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      // 3. Sara text ek sath vapas bhejiye
      return recognizedText.text.isEmpty ? "Bill khali tha" : recognizedText.text;
    } catch (e) {
      return "Galti: ${e.toString()}";
    }
  }

  // App band hone par memory saaf karein
  static void dispose() {
    _textRecognizer.close();
  }
}