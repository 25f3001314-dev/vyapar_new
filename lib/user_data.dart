class UserData {
  // Yahan saare users ka data save hoga
  static List<Map<String, String>> users = []; 

  // ✅ UPDATED: Ab hum 'gst' bhi save kar rahe hain
  // Signup Page se 6 cheezein aayengi, hum unhe yahan list mein daal denge
  static void addUser(String name, String phone, String email, String password, String role, String gst) {
    users.add({
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'role': role,
      'gst': gst, // Yahan GST number save hoga (agar user ne bhara hai to)
    });
  }

  // ✅ LOGIN CHECKER: Ye check karega ki phone aur password sahi hai ya nahi
  static Map<String, String>? checkLogin(String phone, String password) {
    for (var user in users) {
      if (user['phone'] == phone && user['password'] == password) {
        return user; // Agar mil gaya to pura data (Name, Role, GST etc) wapas karo
      }
    }
    return null; // Agar nahi mila to khaali (null) wapas karo
  }
}