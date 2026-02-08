class BillData {
  // Yahan sirf Bills rahenge
  static List<Map<String, dynamic>> allBills = [];

  // Bill add karo
  static void addBill(Map<String, dynamic> bill) {
    allBills.add(bill);
  }
  
  // Bills wapas mango (History ke liye)
  static List<Map<String, dynamic>> getBills() {
    return allBills.reversed.toList();
  }
}